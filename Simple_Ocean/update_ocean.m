function update_ocean

global OPTS
global OCEAN

%% update_psi
% This routing updates the Ocean model, its salinity and temperature

% new Floe Distribution
OCEAN.T = OCEAN.T + OPTS.dt_temp * OCEAN.dTdt;
OCEAN.S = OCEAN.S + OPTS.dt_temp * OCEAN.dSdt; 

end
