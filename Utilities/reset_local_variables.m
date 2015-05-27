%% reset_local_variables
% This code handles the resetting of matrices which are updated during each
% sub-timestep.

psi;

if do_FD == 1
   
   diff_FD = 0*diff_FD; 
   opening = 0*opening; 
   V_max = sum(psi(:,end))*H_max;
   numfloes = psi./(meshR.^2);
   V_max_in = 0;
   V_max_out= 0; 
   
   
end


if do_Mech == 1
    
    % Large-Scale In and Out matrices
    In = 0*In;
    Out = 0*Out;
    
    % Variables related to the changes from single processes
    In_ridge = In;
    In_raft = In;
    Out_ridge = Out;
    Out_raft = Out;
    Out_max_ridge = zeros(length(R),1);
    Out_max_raft = Out_max_ridge;
    In_max_ridge = Out_max_ridge;
    In_max_raft = Out_max_ridge;
    In_max = In_max_raft;
    Out_max = Out_max_raft;
    
end

if do_Swell == 1
    
    In_Swell = 0*In_Swell;
    Out_Swell = 0*Out_Swell; 
    
end




