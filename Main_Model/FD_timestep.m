% This code executes a single predefined timestep of the joint model by
% performing a greedy-minimum number of sub-cycles

% Get the grid-level strain rate state and grid-level thermodynamic state
get_external_forcing;

% Using the current thicknesses, update the propensity for ridging/rafting
update_grid; 

% Reset counting variables and difference matrices
reset_global_variables; 


%% Actual Sub Timestep
while dt_sub > 0
    
    %% Reset all variables that are only relevant for one sub-cycle
    reset_local_variables; 
    
    %% Get Change Due To Mechanics
    
    if do_Mech == 1 && mag ~= 0
        
        if exist('do_Thorndike','var') && do_Thorndike
            Thorndike_timestep; 
        else
        FD_timestep_mech_2;
        end
        
        diff_FD = diff_FD + diff_mech; 
        opening = opening + opening_mech; 
        V_max_in = V_max_in + V_max_in_mech; 
        V_max_out = V_max_out + V_max_out_mech; 
        
    end
    
    %% Get Change Due To Thermodynamics
    
    if do_Thermo == 1 
        
        % This outputs diff_thermo
    
        if exist('do_Hibler','var') && do_Hibler
            Hibler_timestep; 
        else
            FD_timestep_thermo;
        end
        diff_FD = diff_FD + diff_thermo; 
        opening = opening + opening_thermo; 
        V_max_in = V_max_in + V_max_in_thermo; 
        V_max_out = V_max_out + V_max_out_thermo; 
      
    end
    
    %% Get Change Due to Swell
    
    if do_Swell == 1 && stormy(III,i) == 1
        
        FD_timestep_swell; 
        diff_FD = diff_FD + diff_swell;
        V_max_in = V_max_in + V_max_in_swell; 
        V_max_out = V_max_out + V_max_out_swell; 
    
    end
        
    dV_max = V_max_in - V_max_out; 
    
    %% Calculate Changes Due to Interaction

    %% Minimal Timestep
    % Calculate the maximal timestep possible to keep the solution legal    
    dt_temp = calc_max_timestep(psi,diff_FD,dt_sub);

    %%
    dt_temp = calc_max_timestep(V_max,dV_max(end,end),dt_temp,1);
    
    %% Update the main variables psi and openwater
    update_psi;
    
    
    %% Update those local variables which will change on each timestep
    update_local_variables; 
    
    check_FD;
    
end

%% Update variables which are changed on each timestep
update_global_variables; 

