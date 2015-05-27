%% update_ocean
% This routing updates the Ocean model, its salinity and temperature

% new ocean tracers
OCEAN.T = OCEAN.T + OPTS.dt_temp * OCEAN.dTdt;
OCEAN.S = OCEAN.S + OPTS.dt_temp * OCEAN.dSdt; 