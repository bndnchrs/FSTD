% This code executes a single timestep of the joint model

dt_sub = dt;
dt_temp = dt_sub;
numSC = 0;

if sum(n) == 0
    diff = 0*n;
    opening = 0;
    diffeps = eps;
end
%% Sub-cycling

diff_thermo = 0*n;
diff_mech = 0*n;
dhdt_thermo = 0;
dhdt_mech = 0;
opening_thermo = 0;
opening_mech = 0;
pancake_area = 0*n;
opening_ridge = 0;
dt_temp_mech = Inf;
dt_temp_thermo = Inf;

if isnan(n)
    i
    break
    
end

get_strain_rate;

%%

while dt_sub > 0
    
    numSC = numSC + 1;
    
    if numSC == 2
        fprintf('Cutting Timestep @ timestep %d. .',i);
    end
    
    if numSC >= 2
        fprintf('.')
        if numSC == 17
            fprintf('\n');
        else if mod(numSC - 17,50) == 0
                fprintf('\n')
            end
        end
    end
    
    numfloes = n./(pi*R.^2);
    
    if isnan(n)
        i
        break
        
    end
    
    % First we do the mechanics. This will create a minimal mechanical
    % timestep which will be used for updating the thermodynamics
    
    if doMech == 1
        [diff_mech,opening_mech,opening_ridge,Press] = do_timestep_mech(n,H,R,openwater,Prob_Interact_raft,Prob_Interact_ridge, ...
            S_Out_raft,S_Out_ridge,Kfac_raft,Kfac_ridge,H_raft,eps_I,eps_II,alpha_0,alpha_c,P_0,h_p);
        
        
        dt_temp_mech = cut_timestep(n,diff_mech,dt_sub,i,numSC);
        
        % Update as if only mechanical forcing existed
        n_mech = n + dt_temp_mech*diff_mech;
        openwater_mech = openwater + dt_temp_mech*opening_mech;
        
        
        if sum(n_mech) == 0
            dhdt_mech = 0;
        else
            dhdt_mech = opening_ridge*(H/sum(n_mech));
        end
        
        
        H_mech = H + dt_temp_mech*dhdt_mech;
        conc_mech = 1 - openwater_mech;
        
        
    end
    
    %% Now that we have done a mechanical step, we use the new n to evaluate the thermodynamic step
    
    if doThermo == 1
        
        [diff_thermo, dhdt_thermo,opening_thermo,pancake_area] = do_timestep_thermo(n_mech,H_mech,R,openwater_mech,conc_mech,Q_surf(i),dt_temp_mech,h_p);
        
        
        dt_temp_thermo = cut_timestep(n_mech,diff_thermo,dt_temp_mech,i,numSC);
        
    end
    %% Now we have a minimal mechanical timstep and a minimal thermodynamic timestep
    
    dt_temp = min(dt_temp_mech,dt_temp_thermo);
    
    % Total dn
    diff = diff_mech + diff_thermo;
    
    % Total dh
    
    
    % Total opening
    opening = opening_thermo + opening_mech;
    
    %% Minimal Timestep
    
    % If the new n would not be meaningful (i.e. < 0) , we reduce the
    % timestep to its minimal possible value
    
    %dt_temp = cut_timestep(n,diff,dt_sub,i,numSC);
    
    
    n = n + dt_temp*diff;
    openwater = openwater + dt_temp*opening;
    
    
    if sum(n) == 0
        dhdt_mech = 0;
    else
        dhdt_mech = opening_ridge*(H/sum(n));
    end
    
    %%
    dhdt = dhdt_thermo + dhdt_mech;
    
    H = H + dt_temp*dhdt;
    conc = 1 - openwater;
    
    
    pancake_growth = dt_temp*pancake_area;
    
    % If we grew pancakes, we need to adjust the thickness accordingly
    cinit = conc - sum(pancake_growth);
    
    if sum(pancake_growth) ~= 0
        H = (H*cinit + sum(pancake_growth)*h_p)/(conc);
    end
    
    H = max(h_p,H);
    
    
    if H == 0 && Q < 0
        H = h_p;
    end
    
    % We update our timestepping accordingly
    
    % How much time left to go in the timestep
    dt_sub = dt_sub - dt_temp;
    
    % Total time
    time_anal = time_anal + dt_temp;
    
    
    %    If occupying less than min_val, we remove these parts
    resid = sum(n(n < min_n));
    openwater = openwater + resid;
    n(n < min_n) = 0;
    
    if sum(n) < min_n
        n = 0*n;
        H = h_p;
        conc = 0;
        openwater = 1;
    end
    
end

if numSC > 1
    fprintf(' %d subcycles. \n',numSC);
end

numtot = numtot + numSC;

% Save diagnostics

make_outputs;


