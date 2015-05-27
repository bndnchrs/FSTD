function dt_temp = calc_max_timestep(psi,diff_FD,dt_sub,flag)
%% dt_temp = cut_timestep(psi,diff,dt_sub)
% This function counts the maximum timestep possible (< dt_sub) which
% allows the solutions to remain bounded above by 1 and below by 0.

if nargin < 4
    flag = 0; 
end

% Flag allows us to ignore the error that comes when psi is greater than
% one. Useful for re-using this code to deal with thickness. 

psitemp = psi+dt_sub*diff_FD;

dt_temp = dt_sub; 

%%
if min(psitemp(:)) < 0
    
    % if psi is < 0 , we take the maximum timestep possible in order to
    % keep all values >= 0
    less_than_zeros = psitemp(psitemp < 0);
    diff_ltz = diff_FD(psitemp < 0);
    
    dt_temp_ltzs = -(less_than_zeros./diff_ltz) + dt_sub;
    dt_temp = min(dt_temp_ltzs);
    
    %%
    if dt_temp <= 0
        error(sprintf('Cut Timestep is negative, equal to %d',dt_temp))
    end
    
    
else if max(psitemp(:)) > 1 && flag == 0
        % If psi is greater than one, we take the maximum timestep possible
        % in order to keep all values <= 1
        
        greater_than_ones = psitemp(psitemp > 1) - 1;
        diff_gto = diff_FD(psitemp > 1);
        dt_temp_gtos = -(greater_than_ones./diff_gto) + dt_sub;
        dt_temp = min(dt_temp_gtos);
        
        if dt_temp <= 0
            error('Cut Timestep is negative. Psi too big.')
        end
        
    end
end



end