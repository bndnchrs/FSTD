%% Function FD_timestep_mech
% This routing calculates the tendency at each floe size and thickness
% according to the FD parameterizations, and also updates the
% large-ice-thickness class appropriately.

% Reduces mechanical action by reducing the ability of certain size classes
% to participate in interactions

% Press = [H H_max]*exp(-20*openwater)/P_0;
% Press = [H H_max]/H_0;

%% Calculate outgoing term
% 2-dimensional

K_raft =  MECH.Prob_Interact_raft;
% 4-dimensional
K_ridge = MECH.Prob_Interact_ridge;

if FSTD.V_max == 0
    FSTD.H_max = FSTD.H_max_i;
end

% First floe size
for r1 = 1:length(FSTD.R)
    %    for r1 = 1:1
    % First floe thickness
    for r2 = 1:length(FSTD.R)
        % Second floe size
        raft_loc_r = MECH.S_R_raft(r1,r2);
        ridge_loc_r = MECH.S_R_ridge(r1,r2);
        %        for h1 = 1:1
        for h1 = 1:length(FSTD.H)
            % Second floe thickness
            for h2 = 1:length(FSTD.H)
                
                raft_loc_h = MECH.S_H_raft(r1,r2,h1,h2);
                ridge_loc_h = MECH.S_H_ridge(r1,r2,h1,h2);
                
                if ridge_loc_h == length(FSTD.H)+1
                    correct_Hmax_ridge = FSTD.H_max_i/FSTD.H_max;
                else
                    correct_Hmax_ridge = 1;
                end
                
                if raft_loc_h == length(FSTD.H)+1
                    correct_Hmax_raft = FSTD.H_max_i/FSTD.H_max;
                else
                    correct_Hmax_raft = 1;
                end
                
                diagone = .5;
                diagtwo = 1;
                
                if r1 == r2 && h1 == h2
                    diagone = 1;
                    diagtwo = 2;
                end
                
                %% Rafting Step
                if MECH.rafting
                    
                    % In from combination of (r1,h1) and (r2,h2)
                    MECH.In_raft(raft_loc_r,raft_loc_h) = MECH.In_raft(raft_loc_r,raft_loc_h) + ...
                        + diagone*correct_Hmax_raft*MECH.Kfac_raft(r1,r2,h1,h2)*pi*FSTD.R(raft_loc_r)^2*K_raft(r1,r2)*MECH.gamma_raft(h1,h2)* ...
                        FSTD.NumberDist(r1,h1)*FSTD.NumberDist(r2,h2);
                    
                    % Out from rafting combination with (r2,h2)
                    MECH.Out_raft(r1,h1) =  MECH.Out_raft(r1,h1) + ...
                        diagtwo*K_raft(r1,r2)*MECH.gamma_raft(h1,h2)*FSTD.NumberDist(r1,h1)*FSTD.NumberDist(r2,h2)*pi*FSTD.R(r1)^2;
                end
                
                %% Ridging Step
                if MECH.ridging
                    
                    % In from ridging combination of (r1,h1) and (r2,h2)
                    % We also have a probability of collision that depends
                    % on h_1 and h_2 now
                    MECH.In_ridge(ridge_loc_r,ridge_loc_h) = MECH.In_ridge(ridge_loc_r,ridge_loc_h) + ...
                        + diagone*correct_Hmax_ridge*MECH.Kfac_ridge(r1,r2,h1,h2)*pi*FSTD.R(ridge_loc_r)^2*K_ridge(r1,r2)*MECH.gamma_ridge(h1,h2)* ...
                        FSTD.NumberDist(r1,h1)*FSTD.NumberDist(r2,h2);
                    
                    % Out from ridging combination with (r2,h2)
                    MECH.Out_ridge(r1,h1) = MECH.Out_ridge(r1,h1) + ...
                        diagtwo*K_ridge(r1,r2)*MECH.gamma_ridge(h1,h2)*FSTD.NumberDist(r1,h1)*FSTD.NumberDist(r2,h2)*pi*FSTD.R(r1)^2;
                end
                
                % Test to see if it is broken
                
                
            end
            
        end
    end
end

%                if sum(Out_ridge(:)) - sum(In_ridge(:)) < 0
%                    error('Ridge Broken')
%                else
%                    if sum(Out_raft(:)) - sum(In_raft(:)) < 0
%                        error('Raft Broken')
%                    end
%                end

%% Here we handle what happens to the thickest floe class

% We now just treat the top row of floe thicknesses as its
% own FSD which adheres to the usual FSD equation. These
% thick floes will just stay in the thick category
for r1 = 1:length(FSTD.R)
    for r2 = 1:length(FSTD.R)
        
        ridge_loc_r = MECH.S_R_ridge(r1,r2);
        raft_loc_r = MECH.S_R_raft(r1,r2);
        
        diagone = .5;
        diagtwo = 1;
        
        
        
        if r1 == r2
            diagone = 1;
            diagtwo = 2;
        end
        
        %% Rafting Step
        if MECH.rafting
            
            % In from rafting combination of (r1,h_max) and (r2,h_max)
            MECH.In_raft(raft_loc_r,end) = MECH.In_raft(raft_loc_r,end) + ...
                + diagone*K_raft(r1,r2)*MECH.gamma_raft(end,end)*FSTD.NumberDist(r1,end)*FSTD.NumberDist(r2,end) * ...
                pi * FSTD.R(raft_loc_r)^2 * MECH.Kfac_raft(r1,r2,end,end);
            
            % Out from rafting combination of (r1,h_max) and (r2,h_max)
            MECH.Out_raft(r1,end) = MECH.Out_raft(r1,end) + ...
                diagtwo * K_raft(r1,r2)*MECH.gamma_raft(end,end) * FSTD.NumberDist(r1,end) * FSTD.NumberDist(r2,end) * ...
                pi * FSTD.R(r1)^2 ;
            
        end
        
        %% Ridging Step
        if MECH.ridging
            
            % In from ridging combination of (r1,h_max) and (r2,h_max)
            
            
            MECH.In_ridge(ridge_loc_r,end) = MECH.In_ridge(ridge_loc_r,end) + ...
                + diagone*K_ridge(r1,r2)*MECH.gamma_ridge(end,end)*FSTD.NumberDist(r1,end)*FSTD.NumberDist(r2,end) * ...
                pi * FSTD.R(ridge_loc_r)^2 * MECH.Kfac_ridge(r1,r2,end,end);
            
            % Out from ridging combination of (r1,h_max) and (r2,h_max)
            MECH.Out_ridge(r1,end) = MECH.Out_ridge(r1,end) + ...
                diagtwo * K_ridge(r1,r2)*MECH.gamma_ridge(end,end) * FSTD.NumberDist(r1,end) * FSTD.NumberDist(r2,end) * ...
                pi * FSTD.R(r1)^2 ;
        end
        
    end
end


%%
MECH.In = MECH.In_raft + MECH.In_ridge;
MECH.Out = MECH.Out_raft + MECH.Out_ridge;

if sum(MECH.In(:)) > sum(MECH.Out(:))
    error('Creating Volume, In > Out')
end

MECH.diff = MECH.In - MECH.Out;
MECH.diff_raft = MECH.In_raft - MECH.Out_raft;
MECH.diff_ridge = MECH.In_ridge - MECH.Out_ridge;

% This is an ad-hoc way of doing the normalization, but fine here since
% the Kernel is normalized. If In = Out, use eps to make diff = 0.
sum(MECH.diff(:));
sum(abs(MECH.diff(:)));
diffeps = 0;

if sum(sum(abs(MECH.diff))) == 0
    diffeps = eps;
end
%%

% diff_mech is the ridging mode and is normalized to -1
% It tells how much area must be redistributed.
normalizer = sum(sum(MECH.diff)) + diffeps;

MECH.diff = -MECH.diff / normalizer;


%%
MECH.opening_coll = .5*(MECH.mag - MECH.eps_I);
MECH.opening_div = MECH.mag*MECH.alpha_0;


MECH.In = - MECH.mag*MECH.alpha_c*MECH.In / normalizer;
MECH.Out = - MECH.mag*MECH.alpha_c*MECH.Out / normalizer;

% Here is the "convergent mode" part of the total change in ice
% partial concentrations, which tells how much redistribution is
% done in a "volume conserving" way.

MECH.diff = MECH.mag*MECH.alpha_c*MECH.diff;

% At the moment, volume is not conserved: this is because some
% volume has left the "regular" floe sizes to reach the largest
% thickness category, and some of the area has left the largest
% thickness category, as well. We must update the ice thickness in
% this category to reflect these changes
% On the other hand, area has been correctly reported to all floe
% sizes.
MECH.V_max_in = -integrate_FD(MECH.diff(:,1:end-1),FSTD.H,0);

if sum(FSTD.psi(:)) <= 1e-8
    MECH.diff = 0*FSTD.psi;
    MECH.opening = 0;
    diffeps = eps;
    FSTD.psi = 0*psi;
    FSTD.openwater = 1;
end

%%
% This is the total amount of open water formed by the collisions. Positive
% always.
MECH.opening_coll = MECH.mag*MECH.alpha_c;

% This is the total amount of open water diverged or converged.

% opening_curr = mag*alpha_0;

% This is the net effect, the amount of open water that is formed.
% opening_mech = mag;

% The amount of divergence that isn't accounted for by the collision of
% floes. This leads directly to floes being exported.
MECH.divopening = MECH.eps_I;




%% Loss due to divergence of ice
% Loss in proportion to fractional area

% We need to distinguish between convergence and divergence.

% WHEN THERE IS AN ADVECTIVE PARAMETERIZATION THIS WILL NEED TO CHANGE
% DO NOT FORGET THIS!!!!

if MECH.eps_I < 0
    % When there is convergence, we have no new ice that is added so no
    % advective part
    MECH.convdiv = 0;
else
    % When there is divergence, we lose ice since there is advection out
    MECH.convdiv = 1;
end

MECH.diffadv = (FSTD.psi/(sum(sum(FSTD.psi))+diffeps))*MECH.divopening*MECH.convdiv;

% Here is the amount of ice volume which is lost from the largest
% thickness category due to divergenceH
MECH.V_max_out = FSTD.H_max*sum(MECH.diffadv(:,end));

if MECH.V_max_in*OPTS.dt/FSTD.H_max < 1e-8
    MECH.V_max_in = 0;
end

if MECH.V_max_out < eps
    MECH.V_max_out = 0;
end

% Here, now, is the total change in partial concentrations across
% the board, accounting for mechanical combination and divergence
MECH.diff_noadv = MECH.diff;
MECH.diff = MECH.diff - MECH.diffadv;

MECH.opening = -sum(MECH.diff(:));