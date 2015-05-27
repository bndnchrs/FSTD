%% FD_Run
% This is the main driver of a single simulation: it uses
% previously initialized conditions and variables to simulate the floe
% distribution. Failing its external initialization, it contains a call
% initialize itself

if ~exist('driven','var') || driven == 0
    
    % There is a flag first_init in the initialization scheme which
    % computes all required fields if it is asked to.
    
    first_init = 1;
    
    Initialize_FD;
    
end

PLOT_TSTEP = 1;
PLOT_FirstStep = 0;

%%

for i = start_it:end_it
    
    %%
    % Execute one timestep of the model
    
    if do_FD == 1
        
        
        FD_timestep;
        
        
        
        % Compute diagnostic output
        FD_Diagnostics;
        
        
        % Print output and check for errors
        check_FD;
        
    end
    
    if mod(dt*i,30*86400)==0
        fprintf('Month %d of %d \n',round(time(i)/month),round(time(end)/month))
        
        clf
        plot(time(1:i)/year,concsave(1:i))
        drawnow
        
    end
        
    if mod(dt*i,30*12*86400)==0

      
        clf
        FD_TOTALDIFF;
        drawnow
        
        
        
    end
    
    FD_Plot;
    
    drawnow
    
    
    
end

