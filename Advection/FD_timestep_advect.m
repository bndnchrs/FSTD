%% FD_timestep_advect



%% Calculate the rate of area change

if ~ADVECT.out
    % If we aren't advecting things out, no term there. Then the flux
    % through corresponds to a convergence of ice
    
    ADVECT.conv_in = ADVECT.conv_in + ADVECT.fluxthrough;
    ADVECT.fluxthrough = 0; 

end

% Advection through the domain, balanced. 
ADVECT.fluxin = ADVECT.conv_in + ADVECT.fluxthrough;

% Divergence of ice due to local currents
if MECH.DO

    ADVECT.fluxout_mech = MECH.divopening*MECH.convdiv;

end

% Advection through the domain
ADVECT.fluxout = ADVECT.fluxout_mech + ADVECT.fluxthrough;


%% Calculate the change in the FSTD

% Ice is added with the FSTD of the other grid cell
ADVECT.in = ADVECT.FSTD_in * ADVECT.fluxin;

% Ice lost uniformly according to its area
ADVECT.out = (FSTD.psi/(sum(sum(FSTD.psi))))*ADVECT.fluxout;
   
ADVECT.diff = ADVECT.in - ADVECT.out; 

% Really just V_max_delta
ADVECT.V_max_in = FSTD.H_max*sum(ADVECT.diff(:,end));
ADVECT.V_max_out = 0; 