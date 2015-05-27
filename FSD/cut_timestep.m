function dt_temp = cut_timestep(n,diff,dt_sub,i,numSC)

ntemp = n+dt_sub*diff;

if min(ntemp(:)) < 0
    %%
    less_than_zeros = ntemp(ntemp < 0);
    diff_ltz = diff(ntemp < 0);
    
    
    dt_temp_ltzs = -(less_than_zeros./diff_ltz) + dt_sub;
    dt_temp = min(dt_temp_ltzs);
    
    % fprintf('Cutting Timestep at %d from %d to %d, number %d this has been done \n',i,dt_sub,dt_temp,numSC);
    
    % error('1')

else if max(ntemp(:)) > 1
     disp('GT1')
    greater_than_ones = ntemp(ntemp > 1) - 1;
    diff_gto = diff(ntemp > 1);
    
    
    dt_temp_ltzs = -(greater_than_ones./diff_gto) + dt_sub;
    dt_temp = min(dt_temp_ltzs);
        
        
    else
        
        
    dt_temp = dt_sub;
    
    end
end


end