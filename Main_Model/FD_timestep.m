function FD_timestep

global OPTS
global FSTD
global THERMO
global MECH
global SWELL
global OCEAN
global DIAG
global EXFORC

% This code executes a single predefined timestep of the joint model by
% performing a greedy-minimum number of sub-cycles

% Get the grid-level strain rate state and grid-level thermodynamic state
get_external_forcing;

% Using the current thicknesses, update the propensity for ridging/rafting
update_grid; 

% Reset counting variables and difference matrices
reset_global_variables; 


%% Actual Sub Timestep
while OPTS.dt_sub > 0
    
    %% Reset all variables that are only relevant for one sub-cycle
    reset_local_variables; 
    
    %% Get Change Due To Mechanics
    
    if MECH.DO && MECH.mag ~= 0
        
        if MECH.do_thorndike
            Thorndike_timestep; 
        else
            
        FD_timestep_mech;
 
        end
        
        FSTD.diff = FSTD.diff + MECH.diff; 
        FSTD.opening = FSTD.opening + MECH.opening; 
        FSTD.V_max_in = FSTD.V_max_in + MECH.V_max_in; 
        FSTD.V_max_out = FSTD.V_max_out + MECH.V_max_out; 
        
    end
    
    %% Get Change Due To Thermodynamics
    
    if THERMO.DO
        
        % This outputs diff_thermo
    
        if exist('do_Hibler','var') && do_Hibler
            Hibler_timestep; 
        else
            FD_timestep_thermo;
        end
        FSTD.diff = FSTD.diff + THERMO.diff; 
        FSTD.opening = FSTD.opening + THERMO.opening; 
        FSTD.V_max_in = FSTD.V_max_in + THERMO.V_max_in; 
        FSTD.V_max_out = FSTD.V_max_out + THERMO.V_max_out; 
      
    end
    
    %% Get Change Due to Swell
    
    if SWELL.DO == 1 && EXFORC.stormy(FSTD.i)
        
        FD_timestep_swell; 
        FSTD.diff = FSTD.diff + SWELL.diff;
        FSTD.V_max_in = FSTD.V_max_in + SWELL.V_max_in; 
        FSTD.V_max_out = FSTD.V_max_out + SWELL.V_max_out; 
    
    end
        
    %%
    FSTD.dV_max = FSTD.V_max_in - FSTD.V_max_out; 
    
    % Calculate Changes Due to Interaction

    %% Minimal Timestep
    % Calculate the maximal timestep possible to keep the solution legal    
    OPTS.dt_temp = calc_max_timestep(FSTD.psi,FSTD.diff,OPTS.dt_temp);
    
    %%
    OPTS.dt_temp = calc_max_timestep(FSTD.V_max,FSTD.dV_max(end,end),OPTS.dt_temp,1);
    
    %% 
    
    if OCEAN.DO
        
        timestep_ocean;        
        
        % From pancake growth
        % We keep the same timestep here: will this be a problem later?
        FSTD.diff = FSTD.diff + OCEAN.diff; 
        FSTD.opening = FSTD.opening + OCEAN.opening; 
        FSTD.V_max_in = FSTD.V_max_in + OCEAN.V_max_in; 
       
        update_ocean; 
                
    
    end
    
  
        
    
    %% Update the main variables psi and openwater
    update_psi;
    
    
    %% Update those local variables which will change on each timestep
    update_local_variables; 
    
    
    check_FD;
    
end

%% Update variables which are changed on each timestep
update_global_variables; 

end
