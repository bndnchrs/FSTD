%% get_external_forcing
% This routing loads in the strain rate at each timestep as well as the
% thermodynamic input

if do_Mech == 1
    % Get the strain rate
    get_strain_rate;
    
end

if do_Thermo == 1
    % Get the thermodynamic forcing
    get_solar_forcing;
    
end

if do_Swell == 1
    % Get the sea state
    get_sea_state; 
    get_atten_dist; 

end