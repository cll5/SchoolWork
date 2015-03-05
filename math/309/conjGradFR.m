function [x, iter] = conjGradFR(gradF, x0, epsilon, maxIter)
% Fletcher and Reeves Conjugate Gradient Method
% 
% Inputs:
% gradF   - gradient of f(x) (column vector)
% x0      - initial point (column vector)
% epsilon - termination scalar or error tolerance
% maxIter - maximum number of iterations allowed
% 
% Outputs:
% x    - approximate solution
% iter - number of iterations taken


% Check vector orientation
if(size(x0,2) > 1)
    x0 = x0';
end


% Initialization
x = x0;
y = x0;
n = length(x0);
gradF_old = feval(gradF, y);
d = -gradF_old;

% Define indices
k = 1;
j = 1;
iter = 1;


% Main step
while(1)
    if( (norm(gradF_old) < epsilon) || (iter == maxIter) )
        % Exit condition of step 1
        x = y;
        break;
    else
        % Step 1
        thetaPrime = @(z)((gradF(y + (z.*d))')*d);
        
        % Perform line search to find optimal lambda
        lambda = bisection(thetaPrime, 0, 100, 1e-6, 1000);
        
        y = y + (lambda.*d);
        
        if(j < n)
            % Step 2
            gradF_new = feval(gradF, y);
            alpha = (norm(gradF_new)/norm(gradF_old))^2;
            d = (alpha.*d) - gradF_new;
            j = j + 1;
            gradF_old = gradF_new;
            
        else
            % Step 3
            x = y;
            gradF_old = feval(gradF, y);
            d = -gradF_old;
            j = 1;
            k = k + 1;
        end
    end
    
    iter = iter + 1;
end


clear f gradF x0 epsilon maxIter y n gradF_old gradF_new d j k;
clear lambda thetaPrime alpha;