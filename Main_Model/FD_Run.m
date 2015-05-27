function FD_Run
%% FD_Run
% This is the main driver of a single simulation: it uses
% previously initialized conditions and variables to simulate the floe
% distribution. Failing its external initialization, it contains a call
% initialize itself

global OPTS
global FSTD
global THERMO
global MECH
global SWELL
global OCEAN
global DIAG


if isfield(OPTS,'driven') && OPTS.driven == 0
    
    % There is a flag first_init in the initialization scheme which
    % computes all required fields if it is asked to.
        
    Initialize_FD;
    
    if OCEAN.DO
        
        Initialize_Ocean;
        
    end
    
end

DIAG.PLOT_TSTEP = 1;
DIAG.PLOT_FirstStep = 0;

%%

for i =  OPTS.start_it: OPTS.end_it
    
    FSTD.i = i;
    
    %%
    % Execute one timestep of the model
    
    if FSTD.DO
        
        
        FD_timestep;
        
      
        
        % Compute diagnostic output
        if DIAG.DO
            FD_Diagnostics;
        end
        
        % Print output and check for errors
        
    end
       
    if DIAG.DOPLOT
        
        FD_Plot;
        
    end
    
    
    
    drawnow
    
    
    
end

end