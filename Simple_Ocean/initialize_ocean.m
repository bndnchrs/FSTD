function initialize_ocean
% function initialize_ocean
% this function initializes the ocean component of the FSTD model
global OCEAN
global FSTD
global OPTS


if ~isfield(OCEAN,'H')
    
    OCEAN.H = 10; % Mixed Layer Depth
    
end

if ~isfield(OCEAN,'S')
    
    OCEAN.S = 32; % Mixed Layer Salinity
    
end

if ~isfield(OCEAN,'T')
    
    OCEAN.T = 0; % Mixed Layer Temp
    
end

if ~isfield(OCEAN,'rho_ice')
    
    OCEAN.rho_ice = 934; % kg/m^3. Ice Density
    
end

if ~isfield(OCEAN,'cp_w')
    
    OCEAN.cp_w = 4185; % Specific Heat Capacity of Water (J/kg K)
    
end

if ~isfield(OCEAN,'rho_w')
    
    OCEAN.rho_w = 999.8; % kg/m^3. Ocean Density
    
end

if ~isfield(OCEAN,'alpha_T')
    
    OCEAN.alpha_T = 2e-4; % 1/deg C Thermal expansion coeff
    
end

if ~isfield(OCEAN,'beta_S')
    
    OCEAN.beta_S = 7.4e-4; % 1/psu Haline contraction coeff
    
end

if ~isfield(OCEAN,'T_0')
    OCEAN.T_0 = 0; % Deg C Reference Temperature
end

if ~isfield(OCEAN,'S_0')
    OCEAN.S_0 = 32; % ppt Reference Salinity
end

if ~isfield(OCEAN,'no_oi_hf')
    OCEAN.no_oi_hf = 0;
end

if ~isfield(OCEAN,'taui')
    OCEAN.taui = .5*86400; % Relaxation timescale of ice temperature
end

if ~isfield(OCEAN,'EOS')
    OCEAN.EOS = @(T,S) OCEAN.rho_w * (1 - OCEAN.alpha_T * (T - OCEAN.T_0) ...
        + OCEAN.beta_S * ( S - OCEAN.S_0));  
end