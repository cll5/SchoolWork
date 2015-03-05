function [lambda, A, B, iter] = dichotomous(theta, a, b, len, epsilon, maxIter)
% Dichotomous Search Method
% A line search method without using derivatives of the 
% objective function, theta(lambda).
% 
% Inputs:
% -------------------------------------------------------------------
% theta   - Objective function, theta(lambda)
% a       - Lower bound of initial uncertainty interval
% b       - Upper bound of initial uncertainty interval
% len     - Final uncertainty length (must be larger than 2*epsilon)
% epsilon - Distinguishability constant
% maxIter - Maximum number of iterations
% -------------------------------------------------------------------
% 
% 
% Outputs:
% -------------------------------------------------------------------
% lambda - Final lambda value is midpoint of [A, B]
% A      - Lower bound of final uncertainty interval
% B      - Upper bound of final uncertainty interval
% iter   - Number of iterations needed to reach to the
%          final uncertainty length
% -------------------------------------------------------------------
% 
% 
% Written by Chuck Lee
% Version: 2.0
% Created on: Oct. 13, 2012
% Revised on: Oct. 23, 2012
% -------------------------------------------------------------------


% Check if len <= 2*epsilon.
if( len <= (2*epsilon) )
    % Abort if true, and print a message for user to see what happened.
    error('The final uncertainty length must be larger than 2*epsilon!');
end

% Check if a <= b. Swap them if it is not true.
if(a > b)
    temp = a;
    a = b;
    b = temp;
end

% Testing purpose.
%fprintf('   k    a        b       lambda    mu      thetaL   thetaMu\n');
%fprintf('------------------------------------------------------------\n');


% Initialization:
k = 1;  % Iteration counter

% Compute the number of iterations needed to reach to final uncertainty 
% interval.
n = ceil( log2((b - a - (2*epsilon))/(len - (2*epsilon))) );


% Main step:
while(1)
    
    if( (k == n) || (k == maxIter) )
        % Exit condition: final uncertainty interval reached or maximum
        % iterations reached.
        break;
    else
        % Compute the midpoint of the current uncertainty interval.
        midpoint = (a + b)/2;

        % Update the current lambda and mu values using the
        % midpoint and epsilon variables.
        lambda = midpoint - epsilon;
        mu = midpoint + epsilon;

        % Evaluate theta(lambda_k) and theta(mu_k).
        thetaLambda = feval(theta, lambda);
        thetaMu = feval(theta, mu);

        % Testing purpose.
        %fprintf('%4d,  %+.3f,  %+.3f,  %+.3f,  %+.3f,  %+.3f,  %+.3f\n',...
        %        k, a, b, lambda, mu, thetaLambda, thetaMu);
        
        % Update the bounds for the next uncertainty interval.
        if( thetaLambda < thetaMu )
            % theta(lambda_k) < theta(mu_k):
            % Set a_k+1 = a_k
            %     b_k+1 = mu_k

            % Note: Setting a_k+1 = a_k doesn't change the value of
            % variable a. Hence, a is implicitly updated.
            b = mu;

        else
            % theta(lambda_k) >= theta(mu_k):
            % Set a_k+1 = lambda_k
            %     b_k+1 = b_k

            % Note: Setting b_k+1 = b_k doesn't change the value of
            % variable b. Hence, b is implicitly updated.
            a = lambda;
        end
    
        % Update the iteration counter.
        k = k + 1;
    end
end


% The minimum point lies in the final uncertainty interval [A, B].
A = a;
B = b;
iter = k;

% The minimum point is approximated as the midpoint of [A, B].
lambda = (A + B)/2;

% Clear some space in memory.
clear theta a b len epsilon maxIter mu midpoint k n;
clear thetaLambda thetaMu;