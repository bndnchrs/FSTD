%% Temperature Evolution

dens = OCEAN.EOS(OCEAN.T,OCEAN.S);

prefac = OCEAN.cp_w * OCEAN.H * dens;

% This is if the ice thermodynamics is on. If not, we can get the heat flux
% from somewhere else. Not included yet.

if THERMO.DO
    
    % If warming the ocean
    OCEAN.Q_o = THERMO.Q_o;
    
    % In thermodynamics package, THERMO.Q_o has been updated to cool the
    % water if this will bring it to the freezing point and lead to pancake
    % formation. If this is the case, there will be no residual cooling to
    % decrease the water temperature.
    
    % If ocean.q_o is nonzero, either it is warming, or it is cooling but
    % not enough to freeze it.
    
end

%%

% We want to calculate whether we will form pancakes or not.
% If we do, we first calculate how much heat would be required to cool the
% water to its freezing point (qreq)
qreq = (prefac /OPTS.dt_sub) * (OCEAN.Tfrz - OCEAN.T);

%%
% If the heat flux is stronger than this, we let the excess be used to
% freeze pancakes (panQ) and overwrite Q_open to be the reduced heat flux
if OCEAN.Q_o <= qreq
    OCEAN.panQ = OCEAN.Q_o - qreq;
    OCEAN.Q_open = qreq;
else
    OCEAN.panQ = 0; 
    OCEAN.Q_open = OCEAN.Q_o;
end

%%
% The time rate of change of ocean temperature is therefore this open water
% heat flux term, which may have been adjusted (up to 1/(cp rho H))
OCEAN.dTdt = (1/prefac) * OCEAN.Q_open;

% If there is some heat flux to the pancakes, we make them
if OCEAN.panQ < 0 
    % This is assuming they are all the same size and thickness. 
    OCEAN.pancakes = -OCEAN.panQ / (OPTS.L_f * OPTS.rho_ice * OPTS.h_p);
else
    OCEAN.pancakes = 0; 
end


%%
% Pancake Growth array
OCEAN.pancake_growth = 0*FSTD.meshR;
OCEAN.pancake_growth(1,1) = OCEAN.pancakes*OPTS.dt_sub;

% In case we just have a single thickness category, these pancakes go there
OCEAN.dV_max_pancake = sum(OCEAN.pancake_growth(:,end)/OPTS.dt_sub)*OPTS.h_p;
OCEAN.V_max_in =  OCEAN.dV_max_pancake;

% The total dFSD/dt from the ocean
OCEAN.diff = (1/OPTS.dt_sub) * (OCEAN.pancake_growth);
OCEAN.opening = -sum(OCEAN.diff(:));

%%
% We calculate changes in salinity from changes in ice volume. if pancakes
% get formed, we need to add them in here
FSTD.dV_ice = integrate_FD(FSTD.diff + OCEAN.diff,[FSTD.H FSTD.H_max],0);

% Time rate of change of salinity
OCEAN.dSdt = OCEAN.S * (OPTS.rho_ice/dens) * (1 / OCEAN.H) * FSTD.dV_ice;