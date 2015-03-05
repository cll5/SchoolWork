function [Freq,Mag,Phase] = response(Freq,InChan,OutChan)

% This code will generate bode plots (magnitude and phase) from a
% set of frequencies the user has initially defined. The user is also
% allowed to select which of the two oscilloscope channels
% is the input and output.
%
% Sample usage:
%   [Freq,Mag,Phase] = response(Freq, InChan, OutChan)
%
% where
%   Freq - A vector of desired frequencies ranging from 10Hz to 40000Hz
%   InChan - The input channel of the oscilloscope, pick either 1 or 2
%   Outchan - The output channel of the oscilloscope, pick either 1 or 2
%
%   Freq - The same 'Freq' vector the user has inputted
%   Mag - A vector of the magnitudes in dB corresponding to the frequency
%   Phase - A vector of the phases in degrees coressponding to the frequecy

% Preliminary setup before measurements
input = strcat('CH',num2str(InChan));
output = strcat('CH',num2str(OutChan));
n = length(Freq);

% Setup the optimal sec/div of the oscilloscope to obtain at least
% two periods of the input and output waveforms for each frequency
hor_section = zeros(n);
for i = 1:n
    if (10 <= Freq(i)) && (Freq(i) < 14.5)
        hor_section(i) = 25e-3;
    elseif (14.5 <= Freq(i)) && (Freq(i) < 29)
        hor_section(i) = 10e-3;
    elseif (29 <= Freq(i)) && (Freq(i) < 87)
        hor_section(i) = 5e-3;
    elseif (87 <= Freq(i)) && (Freq(i) < 145)
        hor_section(i) = 2.5e-3;
    elseif (145 <= Freq(i)) && (Freq(i) < 290)
        hor_section(i) = 1e-3;
    elseif (290 <= Freq(i)) && (Freq(i) < 870)
        hor_section(i) = 500e-6;
    elseif (870 <= Freq(i)) && (Freq(i) < 1450)
        hor_section(i) = 250e-6;
    elseif (1450 <= Freq(i)) && (Freq(i) < 2900)
        hor_section(i) = 100e-6;
    elseif (2900 <= Freq(i)) && (Freq(i) < 8700)
        hor_section(i) = 50e-6;
    elseif (8700 <= Freq(i)) && (Freq(i) < 14500)
        hor_section(i) = 25e-6;
    elseif (14500 <= Freq(i)) && (Freq(i) < 29000)
        hor_section(i) = 10e-6;
    elseif (29000 <= Freq(i)) && (Freq(i) <= 40000)
        hor_section(i) = 5e-6;
    end
end

% Connect to the Function Generator(generator) and Oscilloscope(scope)
generator = serial('COM1','BaudRate',9600);
scope = serial('COM2','BaudRate',9600,'InputBufferSize',18000);
fopen(generator); fopen(scope);
pause(0.1);

% Setting up the Function Generator
fprintf(generator,':AMPL:UNIT 1'); pause(0.1);
fprintf(generator,':AMPL:VOLT 1.00'); pause(0.1);
fprintf(generator,':FUNC:WAV 1'); pause(0.1);

% Setting up the Oscilloscope
fprintf(scope,':ACQ:MOD AVE; NUMAV 128');
fprintf(scope,':DAT:ENC ASCI; WID 1'); pause(0.1);

% Sets all offset to be zero on the oscilloscope
fprintf(scope,':HOR:POS 0E1');
fprintf(scope,[':' input ':SCA 0.5; COUP AC; POS 0E1']);
fprintf(scope,[':' output ':SCA 0.5; COUP AC; POS 0E1']); pause(0.1);
fprintf(scope,[':TRIG:MAI:LEV 0E1; EDGE:SOU ' input]);
fprintf(scope,':DAT:STAR 1');
fprintf(scope,':HEAD OFF'); pause(0.1);

% Obtain measurements from oscilloscope for the desire frequencies
gain = zeros(n,1);
S = zeros(n,1);
for i = 1:n
    % Due to the oscilloscope inaccuracy readings for extremely small
    % AC signals, we adjusted the code to change the vertical scaling
    % of the output waveform at certain frequency ranges for a more
    % accurate reading from the oscilloscope
    if (Freq(i) >= 6000) && (Freq(i) < 9000)
        fprintf(scope,[':' output ':SCA 0.2']); pause(0.1);
    elseif (Freq(i) >= 9000) && (Freq(i) < 13000)
        fprintf(scope,[':' output ':SCA 0.02']); pause(0.1);
    elseif (Freq(i) >= 13000) && (Freq(i) < 16000)
        fprintf(scope,[':' output ':SCA 0.005']); pause(0.1);
    elseif (Freq(i) >= 16000)
        fprintf(scope,[':' output ':SCA 0.002']); pause(0.1);
    end
    
    % Change the frequency and adjust the oscilloscope accordingly
    fprintf(generator,[':FREQ ' num2str(Freq(i)) ]); pause(2);
    fprintf(scope,[':HOR:SCA ' num2str(hor_section(i)) ]); pause(1);
    
    % Pause the oscilloscope
    fprintf(scope,':ACQ:STATE OFF');
    
    % Measuring the peak-to-peak amplitudes for input and output waveforms
    fprintf(scope,':MEASU:IMM:TYP PK2;UNI V');
    fprintf(scope,[':MEASU:IMM:SOU ' input]);
    fprintf(scope,':MEASU:IMM:VAL?');
    pkIn = str2num(fscanf(scope)); pause(0.1);
    fprintf(scope,[':MEASU:IMM:SOU ' output]);
    fprintf(scope,':MEASU:IMM:VAL?');
    pkOut = str2num(fscanf(scope)); pause(0.1);
    gain(i) = abs(pkOut/pkIn);
    
    % Measuring the periods for input and output waveforms
    fprintf(scope,':MEASU:IMM:TYP PERI;UNI s');
    fprintf(scope,[':MEASU:IMM:SOU ' input]);
    fprintf(scope,':MEASU:IMM:VAL?');
    T1 = str2num(fscanf(scope));
    pause(0.1);
    fprintf(scope,[':MEASU:IMM:SOU ' output]);
    fprintf(scope,':MEASU:IMM:VAL?');
    T2 = str2num(fscanf(scope));
    pause(0.1);
    
    % Measuring the incremental time between each data sample
    fprintf(scope,':WFMP:XIN?');
    time_scale = str2num(fscanf(scope));
    
    % Calculating the approximate number of samples per period for both
    % input(N1) and output(N2) waveforms
    N1 = round((2500*T1)/(time_scale*2499));
    
    % Once a certain frequency range is passed, the output waveform is too
    % small for the oscilloscope to take period measurements, so we used
    % an indirect method to find a slightly less accurate approximation
    % for the number of samples per period
    if Freq(i) >= 22000
        N2 = round(2500/(time_scale*2499*Freq(i)));
    else
        N2 = round((2500*T2)/(time_scale*2499));
    end
    pause(0.1);
    
    % Obtain curve samples for one period of the input waveform
    fprintf(scope,[':DAT:SOU ' input '; STOP ' num2str(N1) ]);
    fprintf(scope,':CURV?');
    waveIn = str2num(fscanf(scope)); pause(0.5);
    fprintf(scope,[':WFMP:' input ':YMU?']);
    yIn_scale = str2num(fscanf(scope));
    fprintf(scope,[':WFMP:' input ':YZE?']);
    yIn_zero = str2num(fscanf(scope));
    Y1 = yIn_zero + (yIn_scale.*waveIn); pause(0.1);
    
    % Obtain curve samples for one period of the input waveform
    fprintf(scope,[':DAT:SOU ' output '; STOP ' num2str(N2) ]);
    fprintf(scope,':CURV?');
    waveOut = str2num(fscanf(scope)); pause(0.5);
    fprintf(scope,[':WFMP:' output ':YMU?']);
    yOut_scale = str2num(fscanf(scope));
    fprintf(scope,[':WFMP:' output ':YZE?']);
    yOut_zero = str2num(fscanf(scope));
    Y2 = yOut_zero + (yOut_scale.*waveOut); pause(0.1);
    
    % Preliminary calculations for computing phase shift
    for k = 1:N1
        Y1(k) = Y1(k)*exp(((1j*2*pi*time_scale)/T1)*k);
    end
    
    if Freq(i) >= 22000
        for k = 1:N2
            Y2(k) = Y2(k)*exp((1j*2*pi*time_scale*Freq(i))*k);
        end
    else
        for k = 1:N2
            Y2(k) = Y2(k)*exp(((1j*2*pi*time_scale)/T2)*k);
        end
    end
    S(i) = sum(Y1)*conj(sum(Y2));
    
    % Run the oscilloscope
    fprintf(scope,':ACQ:STATE ON');
end

% Disconnect and clean up the serial port objects
fclose(generator); fclose(scope);
delete(generator); delete(scope);

% Compute the magnitude in dB, the phase in degrees, and
% the frequency in Hz
Mag(:,1) = 20.*log10(gain);
Phase = zeros(n,1);
for i = 1:n
    % Knowing that the phase drops from 0 degree to -360 degree and that
    % Matlab's arctangent functions only sweep angles from 0 to pi radians
    % or 0 to -pi radians (ie. a semi circle fashion), we adjusted the
    % code to support a continuous angle sweep from 0 to -360 degrees
    if (Freq(i) > 1000) && (imag(S(i)) > 0)
        Phase(i) = ((180/pi)*angle(S(i)))-360;
    else
        Phase(i) = (180/pi)*angle(S(i));
    end
end

% Plot the Frequency Responses
figure;
subplot(2,1,1);
semilogx(Freq,Mag,'.');
title('Magnitude Response');
ylabel('Magitude |H(j\omega)| (dB)'); xlabel('Frequency (Hz)');

subplot(2,1,2);
semilogx(Freq,Phase,'.');
title('Phase Response');
ylabel('Phase \phi(\omega) (degrees)'); xlabel('Frequency (Hz)');