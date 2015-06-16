function [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = Initialize_FD(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN)
%% Initialize_FD
% This second-level program contains calls to the initialization schemes
% for each process

% first_init is a flag that is passed from the main driver.

if OPTS.first_init == 1
    
    FSTD.DO = 1;
    MECH.DO = 0;
    THERMO.DO = 0;
    SWELL.DO = 0;
    DIAG.DO = 0;
    OCEAN.DO = 0;
    DIAG.DOPLOT = 0; 
    
    fprintf('INITIALIZING MAIN MODEL \n');
    
    OPTS.first_init = 0; 
    
end


%% Initialize the Main Model

addpath('./Main_Model/')
addpath('./Utilities/')


if FSTD.DO
    
    FD_initialize_FD;
    
end




%% Initialize the Mechanical Mode

if MECH.DO
    
    addpath('./Mechanics/')
    
    if isfield(MECH,'do_Thorndike') && MECH.do_Thorndike == 1
        addpath('./Thorndike_Mechanics/');
        fprintf('THORNDIKE MECHANICS \n')
        if nr > 1
            error('Thorndike Mechanics does not work with multiple floe categories')
        end
    end
    
    if MECH.DO == 1
        
        fprintf('INITIALIZING MECHANICS \n')
        FD_initialize_mechanics;
        
    end
    
else
    MECH.DO = 0;
end

%% Initialize the Thermodynamic Mode

if isfield(THERMO,'do_Hibler') && THERMO.do_Hibler
    addpath('./Hibler_Thermodynamics/');
    fprintf('HIBLER THERMODYNAMICS \n')
    if nr > 1
        error('Hibler Thermodynamics does not work with multiple floe categories')
    end
end



if THERMO.DO
    
    addpath('./Thermodynamics/')
    
    fprintf('INITIALIZING THERMODYNAMICS \n')
    FD_initialize_thermodynamics;
    
    if THERMO.mergefloes
        addpath('./Merge_Floes')
        FD_initialize_merging; 
    end
    
end



%% Initialize the Swell Mode


if SWELL.DO
    fprintf('INITIALIZING SWELL FRACTURE \n')
    
    addpath('./Swell/')
    
    FD_initialize_swell;
end

%% Initialize the Ocean Model


if OCEAN.DO
    fprintf('INITIALIZING OCEAN MODEL \n')
    
    addpath('./Simple_Ocean/')
    
    initialize_ocean;
    
end



%% Initialize the Diagnostic Mode

if DIAG.DO
    
    addpath('./Diagnostics/')
    
    fprintf('INITIALIZING DIAGNOSTICS \n')
    
    FD_initialize_diagnostics;
    
end


if DIAG.DOPLOT
    
    addpath('./Output/')
    
end



end

