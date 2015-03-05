function result = modexp(b, e, m)
% Matlab function to compute congruences using modular exponentiation.
% 
% Inputs:
%   b - base
%   e - exponent
%   m - modulus
%
% Written by Chuck Lee.
% Reference: Wikipedia - Modular exponentiation.


% Convert inputs to 32-bit unsigned integers.
b = uint32(b);
e = uint32(e);
m = uint32(m);

% Initialize result with 1 as a 32-bit unsigned integer.
result = uint32(1);

% Using Bruce Schneier's algorithm to compute the congruence:
% result = b^e (mod m)
while(e > 0)
    if(bitand(e,uint32(1)) == 1)
        result = mod((result*b),m);
    end
    
    e = bitsrl(e,1);
    b = mod((b*b),m);
end

% Return the result as type double.
result = double(result);

% Clear all other variables beside the result.
clear b e m;