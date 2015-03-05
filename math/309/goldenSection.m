function [lambda, A, B, iter] = goldenSection(theta, a, b, len, maxIter)
% Golden Section Method
% A line search method without using derivatives of the 
% objective function, theta(lambda).
% 
% Inputs:
% -----------------------------------------------------
% theta   - Objective function, theta(lambda)
% a       - Lower bound of initial uncertainty interval
% b       - Upper bound of initial uncertainty interval
% len     - Final uncertainty length
% maxIter - Maximum number of iterations
% -----------------------------------------------------
% 
% 
% Outputs:
% -----------------------------------------------------
% lambda - Final lambda value is midpoint of [A, B]
% A      - Lower bound of final uncertainty interval
% B      - Upper bound of final uncertainty interval
% iter   - Number of iterations needed to reach to the
%          final uncertainty length
% -----------------------------------------------------
% 
% 
% Written by Chuck Lee
% Version: 2.0
% Created on: Oct. 14, 2012
% Revised on: Oct. 23, 2012
% -----------------------------------------------------


% Check if a <= b. Swap them if it is not true.
if(a > b)
    temp = a;
    a = b;
    b = temp;
end

% Testing purpose.
% fprintf('   k    a        b       lambda    mu      thetaL   thetaMu\n');
% fprintf('------------------------------------------------------------\n');


% Initialization:
alpha = 0.618;                      % Golden section method constant
k = 1;                              % Iteration counter
lambda = a + ((1 - alpha)*(b - a)); % Initial value of lambda
mu = a + (alpha*(b - a));           % Initial value of mu

% Evaluate the initial values of theta(lambda_k) and theta(mu_k).
thetaLambda = feval(theta, lambda);
thetaMu = feval(theta, mu);


% Main step:
while(1)
    % Testing purpose.
    % fprintf('%4d,  %+.3f,  %+.3f,  %+.3f,  %+.3f,  %+.3f,  %+.3f\n',...
    %         k, a, b, lambda, mu, thetaLambda, thetaMu);
    
    if( ((b - a) < len) || (k == maxIter) )
        % Exit conditions: final uncertainty length reached or maximum
        % iterations reached.
        break;
        
    elseif(thetaLambda > thetaMu)
        % theta(lambda_k) > theta(mu_k):
        % Set a_k+1 = lambda_k
        %     b_k+1 = b_k
        %     lambda_k+1 = mu_k
        %     mu_k+1 = a_k+1 + alpha*(b_k+1 - a_k+1)
        %     theta(lambda_k+1) = theta(mu_k)
        
        % Note: Setting b_k+1 = b_k doesn't change the value of
        % variable b. Hence, b is implicitly updated.
        a = lambda;
        lambda = mu;
        mu = a + (alpha*(b - a));
        thetaLambda = thetaMu;
        
        % Evaluate theta(mu_k+1).
        thetaMu = feval(theta, mu);
        
    else
        % theta(lambda_k) <= theta(mu_k):
        % Set a_k+1 = a_k
        %     b_k+1 = mu_k
        %     mu_k+1 = lambda_k
        %     lambda_k+1 = a_k+1 + (1 - alpha)*(b_k+1 - a_k+1)
        %     theta(mu_k+1) = theta(lambda_k)
        
        % Note: Setting a_k+1 = a_k doesn't change the value of
        % variable a. Hence, a is implicitly updated.
        b = mu;
        mu = lambda;
        lambda = a + ((1 - alpha)*(b - a));
        thetaMu = thetaLambda;
        
        % Evaluate theta(lambda_k+1).
        thetaLambda = feval(theta, lambda);
    end
    
    % Update the iteration counter.
    k = k + 1;
end


% The minimum point lies in the final uncertainty interval [A, B].
A = a;
B = b;
iter = k;

% The minimum point is approximated as the midpoint of [A, B].
lambda = (A + B)/2;

% Clear some space in memory.
clear theta a b len maxIter alpha k mu thetaLambda thetaMu;