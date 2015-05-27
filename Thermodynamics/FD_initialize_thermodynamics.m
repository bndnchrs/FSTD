function FD_initialize_thermodynamics
%% FD_initialize_thermodynamics
% This routine initializes the thermodynamic component of the FD model.
global FSTD
global OPTS
global THERMO


if FSTD.DO
    
    if ~isfield(OPTS,'rho_ice')
        % Density of ice (kg/m^3)
        OPTS.rho_ice = 934;
    end
    
    if ~isfield(OPTS,'rho_water')
        % Density of water (kg/m^3)
        OPTS.rho_water = 1000;
    end
    
    if ~isfield(OPTS,'alpha_oc')
        % Ocean Albedo
        OPTS.alpha_oc = .1;
    end
    
    if ~isfield(OPTS,'sigma')
        % Stefan Bolzmann Constant
        OPTS.sigma = 5.67e-8;
    end
    
    
    if ~isfield(OPTS,'alpha_ic')
        % Ice Albedo
        OPTS.alpha_ic = .8;
    end
    
    if ~isfield(OPTS,'cp_water')
        % Specific heat of water (J/kg deg C)
        OPTS.cp_water = 3996;
    end
    
    if ~isfield(OPTS,'L_f')
        % Latent heat of freezing for water (J/kg)
        OPTS.L_f = 334000;
    end
    
    if ~isfield(OPTS,'kice')
        % Thermal conductivity of ice (?/m)
        OPTS.kice = 2.03;
    end
    
    if ~isfield(OPTS,'smallfrac')
        % Amount of sea surface guaranteed to be open to solar radiation in
        % melting season... allows for ice to melt
        OPTS.smallfrac = .05;
    end
    
    if ~isfield(THERMO,'T_ice')
        THERMO.T_ice = -5 + zeros(size([FSTD.H FSTD.H_max]));
    end
    
    if ~isfield(THERMO,'Toc')
        THERMO.Toc = 0;
    end
    
    % Whether we allow the thermodynamic loss of thickness to lead to a
    % loss of concentration directly
    if ~isfield(THERMO,'allow_adv_loss')
        THERMO.allow_adv_loss = 0;
    end
    
else
    
    % We didn't initialize the model!
    fprintf('NO MAIN MODEL ENABLED... WONT PROCEED FOR THERMODYNAMICS \n ')
    
end
