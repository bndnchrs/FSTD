function reset_global_variables
%% Reset_global_timestep_variables
% This code handles the resetting of counting variables (like the number of
% internal timesteps) that must be reset at each large-scale timestep. It
% also resets matrices which are used each timestep
global FSTD
global OPTS
global DIAG


% Timestep Markers
OPTS.dt_sub =OPTS.dt;
OPTS.dt_temp = OPTS.dt_sub;
DIAG.numSC = 0;

end