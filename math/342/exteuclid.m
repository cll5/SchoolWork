function [d,x,y] = exteuclid(a,b)
% Matlab function of the extended Euclidean algorithm
% 
% Inputs:
% 
% Outputs:
% 
% Written by Chuck Lee


if(b > a)
    temp = a;
    a = b;
    b = temp;
    clear temp;
end

%Initial step
q = floor(a/b);
r = [a, b, (a - (q*b))];
s = [1, 0, 1];
t = [0, 1, (-q)];
fprintf('\n%i = (%i)%i + %i\n', [r(1), q, r(2), r(3)]);

while(r(3) > 0)
    r(1:2) = r(2:3);
    s(1:2) = s(2:3);
    t(1:2) = t(2:3);
    
    q = floor(r(1)/r(2));
    r(3) = r(1) - (q*r(2));
    s(3) = s(1) - (q*s(2));
    t(3) = t(1) - (q*t(2));
    fprintf('%i = (%i)%i + %i \n', [r(1), q, r(2), r(3)]);
end

x = s(2);
y = t(2);
d = r(2);

fprintf('\n%i = (%i)%i + (%i)%i \n\n', [d, x, a, y, b]);

clear a b q r s t;