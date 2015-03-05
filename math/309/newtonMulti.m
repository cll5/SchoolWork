function [x, iter] = newtonMulti(x0, epsilon, maxIter)
% Newton's Method in multidimension
% This is the method of Newton discussed on page 394 of the 
% textbook.
% 
% Inputs:
% -------------------------------------------------------------
% x0      - Initial x value
% epsilon - Error constant
% maxIter - Maximum number of iterations
% -------------------------------------------------------------
% 
% 
% Outputs:
% -------------------------------------------------------------
% x      - Computed value of x
% iter   - Number of iterations taken to compute x
% -------------------------------------------------------------
% 
% 
% Written by Chuck Lee
% Version: 1.0
% Created on: Oct. 23, 2012
% Revised on: Oct. 23, 2012
% -------------------------------------------------------------


% Check if x0 is a column vector. Transpose it if it is a row vector.
if(size(x0, 1) == 1)
    x0 = x0';
end

% Testing purpose.
fprintf(['  k          x; f(x)                 gradF                HessF',... 
         '              invHessF         invHessF*gradF\n']);

     
% Initialization:
x = x0;     % Initial value of x
k = 1;      % Iteration counter


% Main step:
while(1)
    
    % Computations step:
    funcValue = f(x);               % Compute the value of f(x)
    gradF = gradient(x);            % Compute the gradient of f(x)
    hessianF = hessian(x);          % Compute the Hessian of f(x)
    invHessian = inverse(hessianF); % Compute the inverse of the Hessian
    moveStep = invHessian*gradF;    % Compute [invHessian] * gradF
    
    
    % Testing purpose. Print results.
    fprintf(['%3d, (%+.4f, %+.4f), <%+.4f, %+.4f>, [%+.4f, %+.4f;  ',...
             '[%+.4f, %+.4f;  <%+.4f, %+.4f>\n'],...
            k, x(1), x(2), gradF(1), gradF(2), hessianF(1), hessianF(2),...
            invHessian(1), invHessian(2), moveStep(1), moveStep(2));

    fprintf(['           %+.4f                                     ',...
             '%+.4f, %+.4f]   %+.4f, %+.4f]\n'], funcValue,...
            hessianF(3), hessianF(4), invHessian(3), invHessian(4));
    
        
    if( (k == maxIter) || (norm(gradF) < epsilon) )
        % Exit condition: either the maximum number of iterations has
        % reached or the optimal solution is found.
        break;
    end

    % Evaluate x_k+1
    x = x - moveStep;               % Compute x_k+1

    
    % Update the iteration counter.
    k = k + 1;
end


% Number of iterations taken to compute x
iter = k;

% Clear some space in memory.
clear x0 k gradF hessianF invHessian;


function fValue = f(x)
% Subfunction to compute f(x)

% f(x)
fValue = 2*((x(1) - x(2))^4) + ((2*x(1) - x(2))^2) - 4;


function gradF = gradient(x)
% Subfunction to compute the gradient of f(x)

% Testing purpose.
%gradF = [(4*((x(1) - 2)^3) + 2*(x(1) - 2*x(2))); -4*(x(1) - 2*x(2))];

% Components of gradient of f(x)
fx = 8*((x(1) - x(2))^3) + 4*((2*x(1)) - x(2));
fy = -(8*((x(1) - x(2))^3) + 2*((2*x(1)) - x(2)));

% Gradient of f(x)
gradF = [fx; fy];


function hessF = hessian(x)
% Subfunction to compute the Hessian of f(x)

% Testing purpose.
%hessF = [(12*((x(1) - 2)^2) + 2), -4; -4, 8];

% Components of Hessian of f(x)
squareTerm = (x(1) - x(2))^2;
fxx = 24*squareTerm + 8;
fxy = -(24*squareTerm + 4);
fyy = 24*squareTerm + 2;

% Hessian of f(x)
hessF = [fxx, fxy; fxy, fyy];


function invHess = inverse(H)
% Subfunction to compute the inverse of the Hessian

% Determinant of the Hessian
determinant = (H(1)*H(4)) - (H(2)*H(3));

% Inverse of the Hessian
invHess = [H(4), -H(2); -H(3), H(1)]./determinant;