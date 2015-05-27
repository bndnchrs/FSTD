%% Reset_global_timestep_variables
% This code handles the resetting of counting variables (like the number of
% internal timesteps) that must be reset at each large-scale timestep. It
% also resets matrices which are used each timestep

% Timestep Markers
dt_sub = dt;
dt_temp = dt_sub;
numSC = 0;
