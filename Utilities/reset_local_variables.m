%% reset_local_variables
% This code handles the resetting of matrices which are updated during each
% sub-timestep.

if FSTD.DO
   
   FSTD.diff = 0*FSTD.diff; 
   FSTD.opening = 0*FSTD.opening; 
   FSTD.V_max = sum(FSTD.psi(:,end))*FSTD.H_max;
   FSTD.NumberDist = FSTD.psi./(FSTD.meshR.^2);
   FSTD.V_max_in = 0;
   FSTD.V_max_out= 0; 
   
   
end

%%


if MECH.DO
    
    % Large-Scale In and Out matrices
    MECH.In = 0*MECH.In;
    MECH.Out = 0*MECH.Out;
    
    % Variables related to the changes from single processes
    MECH.In_ridge = MECH.In;
    MECH.In_raft = MECH.In;
    MECH.Out_ridge = MECH.Out;
    MECH.Out_raft = MECH.Out;
    MECH.Out_max_ridge = zeros(length(FSTD.R),1);
    MECH.Out_max_raft = MECH.Out_max_ridge;
    MECH.In_max_ridge = MECH.Out_max_ridge;
    MECH.In_max_raft = MECH.Out_max_ridge;
    MECH.In_max = MECH.In_max_raft;
    MECH.Out_max = MECH.Out_max_raft;
    
end

if SWELL.DO
    
    SWELL.In = 0*SWELL.In;
    SWELL.Out = 0*SWELL.Out; 
    
end




