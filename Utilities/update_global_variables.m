%% update_global_variables
% This routine updates the variables that change each large-scale timestep.
% This includes the making of diagnostic data

psi; 

A_max = sum(psi(:,end));

if A_max > eps
    H_max = V_max / A_max;
else
    H_max = H_max_i;
end

if isnan(A_max)
    H_max = H_max_i; 
end