%% FD_initialize_thermodynamics
% This routine initializes the thermodynamic component of the FD model.

if exist('do_FD','var') && do_FD == 1
    
    if ~exist('rho_ice','var')
        % Density of ice (kg/m^3)
        rho_ice = 934;
    end
    
    if ~exist('rho_water','var')
        % Density of water (kg/m^3)
        rho_water = 1000;
    end
    
    if ~exist('cp_water','var')
        % Specific heat of water (J/kg deg C)
        cp_water = 3996;
    end
    
    if ~exist('L_f','var')
        % Latent heat of freezing for water (J/kg)
        L_f = 334000;
    end
    
    if ~exist('kice','var')
        % Thermal conductivity of ice (?/m)
        kice = 2.03;
    end
    
    if ~exist('T_ocean','var')
        T_ocean = 0; % Ocean temperature... not held fixed
    end
    
    if ~exist('Tatm','var')
        Tatm = -10; % Atmospheric Temperature... held fixed
    end
    
    if ~exist('smallfrac','var')
        % Amount of sea surface guaranteed to be open to solar radiation in
        % melting season... allows for ice to melt
        smallfrac = .05;
    end
    
    if ~exist('Q_surf','var')
        % Ocean surface heat flux
        Q_surf = 300*sin(2*pi*time/year); % Ocean surface heat flux
        Q_diurn = 0*150*cos(2*pi*time/day);
        Q_surf = Q_surf + Q_diurn;
        clear Q_diurn;        
    end
    
    
else
    
    % We didn't initialize the model!
    fprintf('NO MAIN MODEL ENABLED... WONT PROCEED FOR MECHANICS \n ')
    
end
