%% Update_local_variables
% This timestep updates all variables that change on the order of one
% timestep and are not reset, mostly counting variables

% Marginal Distributions
FSD = sum(psi,2);
ITD = sum(psi,1);

% Time Step Related

% How much time left to go in the timestep
dt_sub = dt_sub - dt_temp;

% Our actual time
timestepping = timestepping + dt_temp;

% Counter of sub-cycles, both per global timestep and in totality
numSC = numSC + 1;
totnum = totnum + 1;

% How much volume belongs to the largest floe class.
V_max = V_max + dt_temp*dV_max;

if abs(V_max) < eps && sum(ITD(1:end-1).*H) < eps
    V_max = 0; 
    H_max = HMSAVE(1); 
    psi = 0*psi; 
end

% if do_Thermo == 1
%     % There is a thermodynamic contribution to additional volume
%     V_max = V_max + A_max * dhdt(end) * dt_temp; 
% end


A_max = sum(psi(:,end));

Ameps = 0;

if A_max == 0
    
    Ameps = eps;
    
end

% The top category thickness is simply the ratio of the volume to

H_max = V_max / (Ameps + A_max);

if H_max == 0
    H_max = HMSAVE(1); 
end

% if H_max < H_max_i
%     
%     psi(:,end-1) = psi(:,end-1) + psi(:,end); 
%     psi(:,end) = 0*psi(:,end); 
%     
%     A_max = 0; 
%     V_max = 0; 
%     H_max = H_max_i;  
% end

% if A_max == 0 || V_max == 0
%     
%     H_max = H_max_i; 
% 
% end

