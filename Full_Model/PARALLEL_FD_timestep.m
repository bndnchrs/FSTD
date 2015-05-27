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
    
    countpar = 1; 
     
    if do_Mech == 1 && mag ~= 0
        
        if do_Thorndike
            Scriptname{countpar} = 'Thorndike_timestep';
        else
            Scriptname{countpar} = 'FD_timestep_mech';
        end
        
        countpar = countpar + 1; 
        
    else
      
        diff_mech = 0*diff_FD;
        opening_thermo = 0*opening_mech;
        V_max_in_mech = 0*V_max_in;
        V_max_out_mech = 0*V_max_out;
   
     end
    
    %% Get Change Due To Thermodynamics
    
    if do_Thermo == 1
        
        % This outputs diff_thermo
        
        if do_Hibler
            Scriptname{countpar} = 'Hibler_timestep';
        else
            Scriptname{countpar} = 'FD_timestep_thermo';
        end
        
        
    else
        diff_thermo = 0*diff_FD;
        opening_thermo = 0*opening;
        
        V_max_in_thermo= 0*V_max_in;
        V_max_out_thermo = 0*V_max_out;
    end
    
    %% Get Change Due to Swell
    
    if do_Swell == 1 && stormy(III,i) == 1
        
        Scriptname{countpar} = 'FD_timestep_swell';
        
    else
        
        diff_swell = 0*diff_FD;
        V_max_in_swell = 0*V_max_in;
        V_max_out_swell = 0*V_max_out;

    end
    

    
    %% Get Change Due To Mechanics
    
    
    parfor parind = 1:numtasks
        
        run(Scriptname{parind});
    
    end
        
    
    
    if do_Mech == 1 && mag ~= 0
        
        if do_Thorndike
            Thorndike_timestep;
        else
            j1 = batch('FD_timestep_mech');
        end
        
    else
        diff_mech = 0*diff_FD;
        opening_thermo = 0*opening_mech;
        V_max_in_mech = 0*V_max_in;
        V_max_out_mech = 0*V_max_out;
    end
    
    %% Get Change Due To Thermodynamics
    
    if do_Thermo == 1
        
        % This outputs diff_thermo
        
        if do_Hibler
            Hibler_timestep;
        else
            FD_timestep_thermo;
        end
        
        
    else
        diff_thermo = 0*diff_FD;
        opening_thermo = 0*opening;
        
        V_max_in_thermo= 0*V_max_in;
        V_max_out_thermo = 0*V_max_out;
    end
    
    %% Get Change Due to Swell
    
    if do_Swell == 1 && stormy(III,i) == 1
        
        j2 = batch('FD_timestep_swell');
        
    else
        
        diff_swell = 0*diff_FD;
        V_max_in_swell = 0*V_max_in;
        V_max_out_swell = 0*V_max_out;
    end
    
    if do_Mech
        wait(j1)
        load(j1)
    end
    
    if do_Swell
        wait(j2)
        load(j2)
    end
    
    opening = opening_thermo + opening_mech;
    diff_FD = diff_thermo + diff_mech + diff_swell;
    V_max_in = V_max_in_swell + V_max_in_thermo + V_max_in_mech;
    V_max_out = V_max_out_swell + V_max_out_thermo + V_max_out_mech;
    
    
    
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
    
    
end

%% Update variables which are changed on each timestep
update_global_variables;

