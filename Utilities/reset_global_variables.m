%% Reset_global_variables
% This code handles the resetting of counting variables (like the number of
% internal timesteps) that must be reset at each large-scale timestep. It
% also resets matrices which are used each timestep
% Timestep Markers
OPTS.dt_sub =OPTS.dt;
OPTS.dt_temp = OPTS.dt_sub;
DIAG.numSC = 0;