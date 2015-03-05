function [lambda, iter] = newton(theta1, theta2, init, epsilon, maxIter)
% Newton's Method
% A line search method using the derivative of the 
% objective function, theta.
% 
% Inputs:
% -------------------------------------------------------------
% theta1  - Derivative of the objective function, theta
% theta2  - Second derivative of the objective function, theta
% init    - Initial lambda value
% epsilon - Error constant
% maxIter - Maximum number of iterations
% -------------------------------------------------------------
% 
% 
% Outputs:
% -------------------------------------------------------------
% lambda - Final value of lambda
% iter   - Number of iterations needed to compute lambda
% -------------------------------------------------------------
% 
% 
% Written by Chuck Lee
% Version: 1.0
% Created on: Oct. 15, 2012
% Revised on: Oct. 23, 2012
% -------------------------------------------------------------


% Testing purpose.
%fprintf('   k   lambda_k   1stOrder   2ndOrder\n');
%fprintf('-------------------------------------\n');


% Initialization:
k = 1;                      % Iteration counter
lambda = init;              % Initial value of lambda
lambdaDiff = 2*epsilon;     % Initial absolute error of lambda
thetaPrime = lambdaDiff;    % Initial value of the 1st derivative of theta


% Main step:
while(1)
    
    if( (lambdaDiff < epsilon) || (abs(thetaPrime) < epsilon) || k > maxIter)
        % Exit condition: the absolute error of lambda is smaller than the
        % given error constant, or the optimal solution is reached, or the
        % maximum number of iterations is exceeded.
        break;
    end
    
    % Evaluate the 1st and 2nd order derivatives of theta at lambda_k.
    thetaPrime = feval(theta1, lambda);
    thetaDoublePrime = feval(theta2, lambda);

    % Testing purpose.
    %fprintf('%4d, %+.6f, %+.6f, %+.6f\n',...
    %        k, lambda, thetaPrime, thetaDoublePrime);

    % Evaluate lambda_k+1 and the absolute error of lambda (absolute
    % value of the ratio of the 1st and 2nd order derivatives of theta).
    thetaRatio = -(thetaPrime/thetaDoublePrime);
    lambda = lambda + thetaRatio;
    lambdaDiff = abs(thetaRatio);

    % Update the iteration counter.
    k = k + 1;
end


% The number of iteration taken to reach the final value of lambda.
iter = k;

% Clear some space in memory.
clear theta1 theta2 init epsilon maxIter k;
clear thetaPrime thetaDoublePrime lambdaDiff thetaRatio;