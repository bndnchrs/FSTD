%% FD_load_lin_Output

% This is the Thermo-Only
mat_thermo = matfile('SavedOutput/LinComp/Run1.mat');

% This is the Mech Only
mat_mech = matfile('SavedOutput/LinComp/Run2.mat');

% This is swell only
mat_swell = matfile('SavedOutput/LinComp/Run3.mat');

% get_external_forcing; 
update_grid; 
reset_global_variables; 

while dt_sub > 0
    
    reset_local_variables;
    
    %% Everything is done the same except we pull out the differences from each timestep 
    % From other runs, and don't compute them. 
    
        
    % Mechanics
    
        diff_FD = diff_FD + mat_mech.fulldiffmech(:,:,i);
        opening = opening + mat_mech.openersave(1,i);
        if i > 1
            V_max_in = V_max_in + mat_mech.VMSAVE(1,i) - mat_mech.VMSAVE(1,i-1);
        else
            V_max_in = V_max_in + mat_mech.VMSAVE(1,1);
        end
        
    
        % Thermodynamics
        
        diff_FD = diff_FD + mat_thermo.fulldiffthermo(:,:,i);
        opening = opening + mat_thermo.openersave(1,i);
        
        dhdt = mat_thermo.dhdtsave(:,i);
        
        if i > 1
            V_max_in = V_max_in + mat_thermo.VMSAVE(1,i) - mat_thermo.VMSAVE(1,i-1);
        else
            V_max_in = V_max_in +mat_thermo.VMSAVE(1,1);
        end
        
        
        
    
        % Swell
        diff_FD = diff_FD + mat_swell.fulldiffswell(:,:,i);
        opening = opening + mat_swell.openersave(1,i);
        
        if i > 1
            V_max_in = V_max_in + mat_swell.VMSAVE(1,i) - mat_swell.VMSAVE(1,i-1);
        else
            V_max_in = V_max_in + mat_swell.VMSAVE(1,1);
        end
    
    %% Minimal Timestep
    % Calculate the maximal timestep possible to keep the solution legal
    dt_temp = calc_max_timestep(psi,diff_FD,dt_sub);
    
    %% Update the main variables psi and openwater
    update_psi;
    
    %% Update those local variables which will change on each timestep
    update_local_variables;
    
end

%% Update variables which are changed on each timestep
update_global_variables;

%% Save per-timestep diagnostics
FD_Diagnostics;
