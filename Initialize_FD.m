%% Initialize_FD
% This second-level program contains calls to the initialization schemes
% for each process.

% first_init is a flag that is passed from the main driver.

if ~exist('first_init','var') || first_init == 1
    
    do_FD = 1;
    do_Mech = 0;
    do_Thermo = 0;
    do_Diagnostics = 0;
    do_Swell = 0; 
    
    fprintf('INITIALIZING MAIN MODEL \n'); 
    
end


%% Initialize the Main Model


if exist('do_FD','var')
    
    addpath('./Main_Model/')
    addpath('./Utilities/')
    
    
    if do_FD == 1
        
        FD_initialize_FD;
        
    end
    
else
    
    do_FD = 0;
    
end


%% Initialize the Mechanical Mode

if exist('do_Mech','var')
    
    addpath('./Mechanics/')
    
    if exist('do_Thorndike','var') && do_Thorndike == 1
        addpath('./Thorndike_Mechanics/');
        fprintf('THORNDIKE MECHANICS \n')
        if nr > 1 
            error('Thorndike Mechanics does not work with multiple floe categories')
        end
    end
    
    if do_Mech == 1
        
        fprintf('INITIALIZING MECHANICS \n')
        FD_initialize_mechanics;
        
    end
    
else
    do_Mech = 0;
end

%% Initialize the Thermodynamic Mode

if exist('do_Thermo','var')
    
    if exist('do_Hibler','var') && do_Hibler == 1
        addpath('./Hibler_Thermodynamics/');
        fprintf('HIBLER THERMODYNAMICS \n')
        if nr > 1 
            error('Hibler Thermodynamics does not work with multiple floe categories')
        end
    end
    
    addpath('./Thermodynamics/')
    
    
    if do_Thermo == 1
        fprintf('INITIALIZING THERMODYNAMICS \n')
        FD_initialize_thermodynamics;
    end
    
else
    do_Thermo = 0;
end

%% Initialize the Swell Mode

if exist('do_Swell','var')
    
    addpath('./Swell/')
    
    
    if do_Swell == 1
        fprintf('INITIALIZING SWELL FRACTURE \n')
        FD_initialize_swell;
    end
    
else
    do_Thermo = 0;
end



%% Initialize the Diagnostic Mode

if exist('do_Diagnostics','var')
    
    addpath('./Diagnostics/')
    
    if do_Diagnostics == 1
        
        fprintf('INITIALIZING DIAGNOSTICS \n')
        
        FD_initialize_diagnostics;
    end
    
else
    do_Diagnostics= 0;
end

if exist('do_Plot','var')
    
    addpath('./Output/')
    
    
else
    do_Plot= 0;
end





