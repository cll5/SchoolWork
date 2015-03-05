function [x, k, xuSet] = penalty(alpha, gradF, gradAlpha, x0, u0, beta, epsilon, maxIter)
% Penalty Function Method
% 
% Inputs:
% -------------------------------------------------------------------------
% alpha     - a function handle of the penalty function, alpha
%             (it must be a column vector if alpha is a vector)
% gradF     - a function handle of the gradient of the objective function,
%             f (it must be written as a column vector if the gradient is a
%             vector)
% gradAlpha - a function handle of the gradient of the penalty function,
%             alpha (it must be written as a column vector if the gradient
%             is a vector)
% x0        - initial x value
% u0        - initial mu value
% beta      - the value of beta (i.e., mu_k+1 = beta * mu_k)
% epsilon   - error tolerance of the approximated solution
%             (i.e., termination scalar)
% maxIter   - maximum number of iterations allowed to perform
% -------------------------------------------------------------------------
%
% Outputs:
% -------------------------------------------------------------------------
% x     - the approximated solution, the last finite x_mu in the sequence
% k     - number of iterations taken to find x
% xuSet - a column vector containing (mu_k, x_mu_k) for all k
%         (i.e., the sequence of the x_mu_k)
% -------------------------------------------------------------------------
% 
% version 2.0


% Check vector orientation
if(size(x0,1) > 1)
    x0 = x0';
end


% Initialization
x = x0;
u = u0;
k = 1;

% Define a vector set, xuSet, for the augmented vectors [mu, x_mu]
xuSet = zeros(maxIter, (length(x) + 1));


% Main step
while(1)
    % Generate the auxiliary function and its gradient
    gradient = @(X)(gradF(X) + (u.*gradAlpha(X)));
    
    % Use Fletcher and Reeves conjugate gradient method to find an
    % approximated optimal solution of the auxiliary function
    x = conjGradFR(gradient, x, 1e-7, 200)';
    xuSet(k,:) = [u, x];
    
    if( ((u*alpha(x)) < epsilon) || (k == maxIter) || (sum(~isfinite(x)) > 0) )
        % Exit conditions: Either an approximated optimal solution is found
        % or the maximum iteration is reached or if a non-finite number is
        % found
        if(sum(~isfinite(x)) > 0)
            % If a non-finite number is found, take the last finite value
            % as the solution
            x = xuSet((k-1),:);
        end
        break;
    else
        % Update mu and the interation counter
        u = beta*u;
        k = k + 1;
    end
end

% Truncate the set if k is less than maxIter
xuSet = xuSet((1:k), :);
clear x0 u0 beta epsilon maxIter;