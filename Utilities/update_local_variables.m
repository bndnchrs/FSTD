%% Update_local_variables
% This timestep updates all variables that change on the order of one
% timestep and are not reset, mostly counting variables

% Marginal Distributions
FSTD.FSD = sum(FSTD.psi,2);
FSTD.ITD = sum(FSTD.psi,1);

% Time Step Related

% How much time left to go in the timestep
OPTS.dt_sub = OPTS.dt_sub - OPTS.dt_temp;

% Our actual time
OPTS.timestepping = OPTS.timestepping + OPTS.dt_temp;

% Counter of sub-cycles, both per global timestep and in totality
DIAG.numSC = DIAG.numSC + 1;
OPTS.totnum = OPTS.totnum + 1;

% How much volume belongs to the largest floe class.
FSTD.V_max = FSTD.V_max + OPTS.dt_temp*FSTD.dV_max;

if abs(FSTD.V_max) < eps % && sum(FSTD.ITD(1:end-1).*FSTD.H) < eps
    FSTD.V_max = 0; 
    FSTD.H_max = FSTD.H_max_i;
    if sum(FSTD.ITD(1:end-1).*FSTD.H) < eps
    FSTD.psi = 0*FSTD.psi; 
    end
end

% if do_Thermo == 1
%     % There is a thermodynamic contribution to additional volume
%     V_max = V_max + A_max * dhdt(end) * dt_temp; 
% end


FSTD.A_max = sum(FSTD.psi(:,end));

Ameps = 0;

if FSTD.A_max == 0
    
    Ameps = eps;
    
end

% The top category thickness is simply the ratio of the volume to

FSTD.H_max = FSTD.V_max / (Ameps + FSTD.A_max);

if FSTD.H_max == 0
    FSTD.H_max = FSTD.H_max_i; 
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

