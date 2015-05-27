%% get_external_forcing
% This routing loads in the strain rate at each timestep as well as the
% thermodynamic input

if MECH.DO
    % Get the strain rate
    get_strain_rate;
    
end

if THERMO.DO
    
    % Get the thermodynamic forcing
    get_thermo_forcing;
    
end

if SWELL.DO
    
    % Get the sea state
    get_sea_state; 
    get_atten_dist; 

end