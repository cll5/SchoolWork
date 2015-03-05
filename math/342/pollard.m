function p = pollard(n, b, kmax)
% MATLAB function to perform Pollard p-1 factorization method.
% 
% Input:
%   n    - a positive integer
%   b    - the base of the congruence
%   kmax - maximum number of iterations to perform
% 
% Outputs:
%   p - a non-trivial divisor of n
% 
% Written by Chuck Lee


% Check if at least one input is given (i.e. n must be given as an input).
switch nargin
    case 0
        % Give an error message when no inputs are given.
        error('Warning: Must input a positive integer n.');
    case 1 
        % When only n is given, use default values and inform the user.
        % Default values: b = 2, kmax = 1000.
        b = 2;
        kmax = 1000;
        fprintf('\nDefault settings:\n');
        fprintf('The base of the congruence is b = %i.\n', b);
        fprintf('The maximum number of iterations allowed is kmax = %i.\n', kmax);
    case 2
        % When kmax is not given, use a default value and inform the user.
        % Default value: kmax = 1000.
        kmax = 1000;
        fprintf('\nDefault setting:\n');
        fprintf('The maximum number of iterations allowed is kmax = %i.\n', kmax);
end
% Check if the value of n exceeds 16 bits. See at the end of this file for
% the reason of this check.
checkn(n);

% Initialize a while loop condition, p, the base, r and the number of
% iterative steps, k.
p = 1;
r = b;
k = 0;

% Iterative step.
% Condition to stop: either a non-trivial divisor is found or the number of
% iterations exceed the maximum number of iterations, kmax.
while( (p == 1) && (k < kmax) )
    % Compute the congruence r(k) = r(k-1)^k (mod n).
    r = modexp(r, (k+2), n);
    
    % M > 0 since it's the least positive residue mod n.
    M = r - 1 + (n*(r == 0));
    
    % Compute the GCD of M and n
    p = gcd(M,n);
    
    % Increment k.
    k = k + 1;
end

% Display the results.
if(p > 1)
    % A non-trivial divisor is found.
    fprintf('\nA non-trivial divisor of %i is p = %i.\n', [n,p]);
    fprintf('It took %i iterations to perform.\n\n', k);
elseif(p == 1)
    % Cannot find a non-trivial divisor within the maximum number of iterations.
    fprintf('\nERROR: Cannot find a non-trivial divisor of %i within %i iterations.\n', [n,kmax]);
    fprintf('Please try another base other than %i or choose a larger upper bound of iterations.\n\n', b);
end

% Clear all variables except the output.
clear n b kmax k r M;


function checkn(n)
% Sub-function to check if the value of n exceeds 16-bits.
% Modular exponentiation implementation only works up to 32-biits for n^2.
if(n > intmax('uint16'))
    error('Warning: This algorithm is implemented for values of n <= %i.',...
        intmax('uint16'));
end