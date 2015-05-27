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

for i = start_it:end_it
    
    %% 
    
    % Load 
    FD_load_lin_Output
    
    % Compute diagnostic output
    FD_Diagnostics;
    
    % Print output and check for errors
    check_FD;
    
    FD_Plot; 

end

