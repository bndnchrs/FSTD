%% FD_initialize_mechanics

if exist('do_FD','var') && do_FD == 1
    
    %% Strain Rate
    
    if ~exist('strain_tensor')
        
        strain_tensor = 0*(rand(2,2,1)-.5)*1e-6;
        
    end
    
    if ~exist('eps_I','var')
        eps_I = -1e-7;
    end
    
    if ~exist('eps_I_0','var')
        eps_I_0 = eps_I;
    end
    
    
    
    if ~exist('eps_II','var');
        eps_II = 0;
    end
    
    if ~exist('eps_II_0','var')
        eps_II_0 = eps_II;
    end
    
    
    % Whether rafting is turned on or not
    if ~exist('rafting','var')
        rafting = 1;
    end
    
    % Whether ridging is turned on or not
    if ~exist('ridging','var')
        ridging = 1;
    end
    
    if ~exist('r_raft','var')
        % Size of a raft
        r_raft = 10;
    end
    
    if ~exist('r_ridge','var')
        % Size of a ridge
        r_ridge = 5;
    end
    
    if ~exist('k_ridge','var')
        % Thickness Increase Multiple
        k_ridge = 5;
        
    end
    
    if ~exist('H_raft','var')
        % Size at which rafting is suppressed
        H_raft = .3;
    end
    
    if ~exist('nu','var')
        % Size at which rafting is suppressed
        nu = zeros(nt,2);
        nu(:,1) = eps_I;
        nu(:,2) = eps_II;
        
    end
    
    if ~exist('dont_guarantee_bigger','var')
        
        dont_guarantee_bigger=0;
    end
    
    if ~exist('use_old_interactions','var')
        use_old_interactions = 0;
    end
    
    % Ridging and rafting matrices
    gamma_raft = calc_gamma_raft_FD([H H_max],meshH,H_raft);
    gamma_ridge = 1 - gamma_raft;
    
    
    % Interaction Matrices for Rafting
    if exist('D4_Ridging','var') && D4_Ridging == 1
        intstr = sprintf('./Mechanics/Interaction_Matrices_4D/nr%drm%dnh%dhm%drra%drri%dkri%d',nr,round(max(R)),nh,round(max(H)),r_raft,r_ridge,k_ridge);
        disp('4D_Ridging')
    else
        intstr = sprintf('./Mechanics/Interaction_Matrices/nr%drm%dnh%dhm%drra%drri%dkri%d',nr,round(max(R)),nh,round(max(H)),r_raft,r_ridge,k_ridge);
        
    end
    
    if exist('use_old_interactions','var') && use_old_interactions == 1
        
        intstr = [intstr 'old'];
        
    else
        
        intstr = [intstr 'new'];
        
    end
    
    if exist('dont_guarantee_bigger','var') && dont_guarantee_bigger == 1
        intstr = [intstr '_dgb'];
    end
    
    try
        
        load(intstr)
        fprintf('Was able to find an interaction scheme matching the initial conditions \n')
        
    catch errloading
        
        % Make sure the file didn't exist and it isn't something else
        
        if strcmp(errloading.identifier ,'MATLAB:load:couldNotReadFile')
            
            if ~exist('rafting','var') || rafting == 1
                
                rafting = 1;
                
                disp('Calculating Interaction Matrices for Rafting ...')
                
                if ~(exist('use_old_interactions','var') && use_old_interactions == 1)
                    disp('Using the new method!')
                end
                
                if exist('dont_guarantee_bigger','var') && dont_guarantee_bigger == 1
                    disp('Not guaranteeing bigger floes!')
                end
                
                [S_R_raft,S_H_raft,Kfac_raft,Prob_Interact_raft] = ...
                    calc_sizes_raft_FD(R,r_raft,A_tot,[H H_max],dont_guarantee_bigger,use_old_interactions);
                
                save(intstr,'S_R_*','S_H_*','Kfac*','Prob_Interact_*');
            end
            
            
            
            % Interaction Matrices for Ridging
            if ~exist('ridging','var') || ridging == 1
                
                ridging = 1;
                
                disp('Calculating Interaction Matrices for Ridging ...')
                
                if ~(exist('use_old_interactions','var') && use_old_interactions == 1)
                    disp('Using the new method!')
                end
                
                if exist('dont_guarantee_bigger','var') && dont_guarantee_bigger == 1
                    disp('Not guaranteeing bigger floes!')
                end
                
                if exist('D4_Ridging','var') && D4_Ridging == 1
                    [S_R_ridge,S_H_ridge,Kfac_ridge,Prob_Interact_ridge] = ...
                        calc_sizes_ridge_FD_2(R,A_tot,[H H_max],dont_guarantee_bigger,use_old_interactions);
                    
                    save(intstr,'S_R_*','S_H_*','Kfac*','Prob_Interact_*');
                    
                else
                    
                    [S_R_ridge,S_H_ridge,Kfac_ridge,Prob_Interact_ridge] = ...
                        calc_sizes_ridge_FD(R,r_ridge,A_tot,k_ridge,[H H_max],dont_guarantee_bigger,use_old_interactions);
                    save(intstr,'S_R_*','S_H_*','Kfac*','Prob_Interact_*');
                    
                end
                
            end
            
        else
            
            % Not sure what this error may be
            throw(errloading)
        end
        
    end
    
    H_0 = integrate_FD(psi,[H H_max],1);
    
    if H_0 == 0
        H_0 = h_p;
    end
    % Initial Pressure
    P_0 = H_0*exp(-20*openwater);
    
    %% Matrices involved in updating psi
    In = zeros(length(R),length(H)+1);
    In_raft = In;
    In_ridge = In;
    Out = In;
    Out_raft = In;
    Out_ridge = In;
    
    
else
    
    % We didn't initialize the model!
    fprintf('NO MAIN MODEL ENABLED... WONT PROCEED FOR MECHANICS \n ')
    
end