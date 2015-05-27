function [diff,opening,divopening,open_ridge, Press] = do_timestep_mech(n,H,R,openwater,Prob_Interact_raft,Prob_Interact_ridge,S_Out_raft,S_Out_ridge,Kfac_raft,Kfac_ridge,H_raft,eps_I,eps_II,alpha_0,alpha_c,P_0,H_0)

In = 0*R;
Out = In; 

Press = H*exp(-20*openwater)/P_0;

eps_I = eps_I*(H_0/H);

mag = sqrt(eps_I^2 + eps_II^2);

gamma_ridge = calc_gamma_ridge(H,H_raft);

numfloes = n./(pi*R.^2);

%%

% Here we control for the fact that we have no thickness or momentum
% equations. Strain rates will depend on the constituent properties of
% the ice, but we have nothing here to determine them. Thus we must
% have the strain rate have some simple dependence on the thickness of
% the ice. As the ice becomes thicker, PE goes like H^2, and so as the
% PE required increases, the straining decreases.
In = 0*In;
In_ridge = In;
In_raft = In;
Out = 0*Out;
Out_ridge = Out;
Out_raft = Out;

K_raft =  Prob_Interact_raft;
K_ridge = Prob_Interact_ridge;

for j = 1:length(R)
    for k = 1:length(R)
        % In from combination of i and j in rafting
        
        % Along diagonal, need to be aware of double-counting
        diagone = .5;
        diagtwo = 1;
        
        if j == k
            diagone = 1;
            diagtwo = 2;
        end
        
        In_raft(S_Out_raft(j,k)) = In_raft(S_Out_raft(j,k)) + diagone*K_raft(j,k)*numfloes(j)*numfloes(k)*R(S_Out_raft(j,k))^2*Kfac_raft(j,k);
        % Out from combination with j
        Out_raft(j) = Out_raft(j) + diagtwo*K_raft(j,k)*numfloes(j)*numfloes(k)*R(j)^2;
        
        % In from combination of i and j in ridging
        In_ridge(S_Out_ridge(j,k)) = In_ridge(S_Out_ridge(j,k)) + diagone*K_ridge(j,k)*numfloes(j)*numfloes(k)*R(S_Out_ridge(j,k))^2*Kfac_ridge(j,k);
        % Out from combination with j
        Out_ridge(j) = Out_ridge(j) + diagtwo*K_ridge(j,k)*numfloes(j)*numfloes(k)*R(j)^2;
        
    end
end

In = (1 - gamma_ridge) * In_raft + gamma_ridge * In_ridge;
Out = (1 - gamma_ridge) * Out_raft + gamma_ridge * Out_ridge;

diff = In - Out;

% This is an ad-hoc way of doing the normalization, but fine here since
% the Kernel is normalized. If In = Out, use eps to make diff = 0.
diffeps = 0;

if sum(abs(diff)) == 0
    diffeps = eps;
end

% Divopening is the divergent mode.

divopening = mag*alpha_0;


% diff is the ridging mode, must be normalized to -1.
diff = -diff / (sum(diff)+diffeps);


% diff allows for some divergence, but not all of it

open_ridge = alpha_c*mag; 
diff = mag*alpha_c*diff;

% Open water is that from divergence + that freed up by convergence
opening = divopening - sum(diff);

if sum(n) == 0
    diff = 0*n;
    opening = 0;
    diffeps = eps;
end

%% Loss due to divergence by ocean currents
        
        diffadv = (n/(sum(n)+diffeps))*divopening;
        
        diff = diff - diffadv;
      

% end