%% get_external_forcing
% This routing loads in the strain rate at each timestep as well as the
% thermodynamic input

if MECH.DO
    % Get the strain rate
    MECH = get_strain_rate(FSTD,MECH,EXFORC);
    
end

if THERMO.DO
    
    % Get the thermodynamic forcing
    [EXFORC,OCEAN] = get_thermo_forcing(FSTD,OPTS,THERMO,EXFORC,OCEAN);
    
end

if SWELL.DO
    
    % Get the sea state
    SWELL = get_sea_state(FSTD,SWELL,EXFORC);
    SWELL = get_atten_dist(FSTD,OPTS,SWELL); 

end