function [p,q] = fermatfactor(n)
% MATLAB function to perform Fermat factorization method.
% 
% Input:
%   n - a positive integer
% 
% Outputs:
%   p,q - factored primes
% 
% Written by Chuck Lee


% Initialize t, i and a while loop condition
t = ceil(sqrt(n));
i = 0;
y = 0.5;

% Iteration step.
% Condition to stop: when ceil(y) == floor(y), meaning y is an integer
while(ceil(y) > floor(y))
    x = t + i;
    y = sqrt( (x^2) - n );
    
    % Increment i by 1.
    i = i + 1;
end

% Compute the primes p and q.
p = x + y;
q = x - y;

% Display the result and the number of steps to iterate it.
if(q == 1)
    fprintf('\n%i is a prime.\n', n);
else
    fprintf('\nThe prime factors of %i are p = %i and q = %i.\n',[n,p,q]);
end
fprintf('It took %i iterations to factorize.\n\n', i);

% Clear all variables except the outputs.
clear n t i flag x y;