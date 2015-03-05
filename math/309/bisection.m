function [lambda, A, B, iter] = bisection(theta1, a, b, len, maxIter)
% Bisection Search Method
% A line search method using the derivative of the 
% objective function, theta(lambda).
% 
% Inputs:
% -------------------------------------------------------------
% theta1  - Derivative of the objective function, theta(lambda)
% a       - Lower bound of initial uncertainty interval
% b       - Upper bound of initial uncertainty interval
% len     - Final uncertainty length
% maxIter - Maximum number of iterations
% -------------------------------------------------------------
% 
% 
% Outputs:
% -------------------------------------------------------------
% lambda - Final lambda value is midpoint of [A, B]
% A      - Lower bound of final uncertainty interval
% B      - Upper bound of final uncertainty interval
% iter   - Number of iterations needed to reach to the
%          final uncertainty length
% -------------------------------------------------------------
% 
% 
% Written by Chuck Lee
% Version: 2.1
% Created on: Oct. 15, 2012
% Revised on: Nov. 17, 2012
% -------------------------------------------------------------


% Check if a <= b. Swap them if it is not true.
if(a > b)
    temp = a;
    a = b;
    b = temp;
end

% Testing purpose.
% fprintf('   k   a        b        lambda   thetaPrime\n');
% fprintf('--------------------------------------------\n');


% Initialization:
k = 1;                         % Iteration counter
n = ceil( log2((b - a)/len) ); % Number of iterations needed to reach 
                               % the final uncertainty interval
m = min(n, maxIter);           % Smaller of either the maximum iteration
                               % or n; used as termination condition
                               

% Main step:
while(1)
    
    % Evaluate lambda_k and thetaPrime(lambda_k).
    lambda = (a + b)/2;
    thetaPrime = feval(theta1, lambda);
    
    % Testing purpose.
    % fprintf('%4d, %+.4f, %+.4f, %+.4f, %+.4f\n',...
    %         k, a, b, lambda, thetaPrime);
    
    if(thetaPrime == 0)
        % Exit condition: optimal solution is found.
        break;
        
    elseif(thetaPrime > 0)
        % thetaPrime > 0:
        % Set a_k+1 = a_k
        %     b_k+1 = lambda_k
        
        % Note: Setting a_k+1 = a_k doesn't change the value of
        % variable a. Hence, a is implicitly updated.
        b = lambda;
        
    else
        % thetaPrime < 0:
        % Set a_k+1 = lambda_k
        %     b_k+1 = b_k
        
        % Note: Setting b_k+1 = b_k doesn't change the value of
        % variable b. Hence, b is implicitly updated.
        a = lambda;
    end
    
    if(k == m)
        % Exit conditions: final uncertainty length reached or maximum
        % iterations reached, whichever is smaller.
        break;
    else
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
clear theta1 a b len maxIter k n m thetaPrime;