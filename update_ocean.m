%% update_ocean


OCEAN.T = OCEAN.T + OPTS.dt_temp*OCEAN.dTdt;

OCEAN.S = OCEAN.S + OPTS.dt_temp*OCEAN.dSdt;

OCEAN.rho = OCEAN.EOS(OCEAN.T,OCEAN.S); 
