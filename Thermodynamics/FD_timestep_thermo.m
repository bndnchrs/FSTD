%% FD_timestep_thermo
% This routing calculates the tendency due to one thermodynamic timestep
% Calculate total floe surface area per sea surface area
% [meshRthermo,~] = meshgrid([OPTS.r_p FSTD.R(2:end)],[FSTD.H FSTD.H_max]);


FSTD.SAmean = integrate_FD(FSTD.psi,2*bsxfun(@rdivide,[FSTD.H FSTD.H_max],FSTD.R'),1);

if FSTD.SAmean == 0;
    FSTD.SAmean = Inf;
end

% Determine what portion of the heat flux goes where over open water
partition_lead_heat_flux;

%% Do Horizontal Growth Rate from Lead Heat FLux

% Horizontal floe growth rate
THERMO.drdt = -THERMO.Q_lat/(OPTS.rho_ice*OPTS.L_f*FSTD.SAmean);

% If we are heating, generally, then we might want to let some heat flux
% reach the ocean surface rather than be in the ice.

% if EXFORC.Q_oc > 0 % Some small area is open to heat fom the atmosphere
%     
%     % QLmin is the small fraction
%     if isfield(OPTS,'qlmin') && OPTS.qlmin == 0;
%         % Lead fraction is at least smallfrac
%         THERMO.Al = max(THERMO.Al,THERMO.smallfrac);
%         THERMO.Q_l = THERMO.Q*THERMO.Al;
%         THERMO.Q_lat = THERMO.Q_l * (FSTD.SAmean/(FSTD.SAmean + FSTD.conc));
%         
%         % If ice concentration is zero, just say all lead heat flux is
%         % lateral
%         if FSTD.conc < eps
%             
%             THERMO.Q_lat = THERMO.Q_l;
%             
%             
%         end
%         
%         
%         if FSTD.SAmean == Inf
%             
%             THERMO.Q_lat = 0;
%             
%         end
%         
%         % Q_vert = Q - Q_o - Q_l; % Heat Flux to ice top. Not used.
%         THERMO.Q_bas = THERMO.Q_l - THERMO.Q_lat;
%         
%     end
%     
% end

% This is the lateral growth rate per floe
THERMO.drdt = -THERMO.Q_lat/(OPTS.rho_ice*OPTS.L_f*(FSTD.SAmean));
% This is that impact on total area growth per floe size
THERMO.edgegrowth = OPTS.dt_sub*(2./FSTD.meshR).*FSTD.psi*THERMO.drdt;

%% Do Pancake Growth Rate from open water heat flux
if THERMO.Q_o < 0 && ~OCEAN.DO
        THERMO.pancakes = -THERMO.Q_o / (OPTS.L_f * OPTS.rho_ice * OPTS.h_p);
else
    THERMO.pancakes = 0;
end
THERMO.pancake_growth = 0*FSTD.meshR;
THERMO.pancake_growth(1,1) = THERMO.pancakes*OPTS.dt_sub;

%% Now Vertical Thermodynamics
%
% Using Semtner Thermo, simple 1-D model using net heat flux to the ice
% without longwave. This is calculated locally at each ice floe. 
[THERMO.dhdt_surf,THERMO.dhdt_base,THERMO.Q_cond,THERMO.Q_atm,THERMO.T_ice] = semtner_1D_thermo(EXFORC.Q_ic_noLW,THERMO.Q_bas,[FSTD.H FSTD.H_max],THERMO.T_ice);

% dhdt_surf is melting at surface for a single column of ice
% dhdt_base is melting/growth at base " " " "
% Q_cond is the conductive heat flux to the base for a single column of ice
% Q_atm is the heat budget at the surface for " " " "
% T_new is the ice temperature given these external forcings

% We now get the total outgoing LW heat fluxes
THERMO.Q_lw = OPTS.sigma * (THERMO.T_ice + 273.14).^4;

% Atmosphere - Radiative Net heat flux at surface for ice
EXFORC.Q_ic = EXFORC.Q_ic_noLW - THERMO.Q_lw;

THERMO.dhdt = (THERMO.dhdt_surf + THERMO.dhdt_base);

if FSTD.conc == 0
    THERMO.dhdt = zeros(size(THERMO.dhdt));
end

%% Advective Tendencies
v_r = repmat(THERMO.drdt,size(FSTD.psi));
v_h = repmat(THERMO.dhdt,[length(FSTD.R),1]);

% This is the simple upwind advection scheme for doing this. It conserves
% volume and area as in Hibler (1980)

[THERMO.adv_tend,THERMO.meltoutR,THERMO.meltoutH] = advect2_upwind(FSTD.psi,FSTD.R,[FSTD.H FSTD.H_max],v_r,v_h,OPTS.dt_sub,THERMO.allow_adv_loss_R,THERMO.allow_adv_loss_H);

if(isnan(sum(THERMO.adv_tend(:))))
    
    error('isnan advtend');
    
end

%%
clear v_r v_h

THERMO.diff = (1/OPTS.dt_sub) * (THERMO.adv_tend + THERMO.pancake_growth + THERMO.edgegrowth);

%%
THERMO.opening = -sum(THERMO.diff(:));

%% Handle volume losses at the thickest floe size category

if EXFORC.Q_oc < 0
    % If we are freezing, the amount of ice volume added is equal to the
    % incoming ice multiplied by that ice's thickness
    if ~isempty(FSTD.H)
        THERMO.dV_max_adv = sum(THERMO.adv_tend(:,end)*FSTD.H(end))/OPTS.dt_sub;
    else
        % There is no advective flux between thickness classes as there are no
        % thickness classes
        THERMO.dV_max_adv = 0;
    end
    
else
    % Otherwise it is equal to the lost ice volume at the largest size
    if ~isempty(FSTD.H)
        THERMO.dV_max_adv = sum(THERMO.adv_tend(:,end)*FSTD.H_max)/OPTS.dt_sub;
    else
        % again, no advective flux because there are no thickness classes
        THERMO.dV_max_adv = 0;
    end
end

% Added volume is equal to dhdt * psi(r,h_max)
THERMO.dV_max_basal = sum(FSTD.psi(:,end)*THERMO.dhdt(:,end));

% The actual ice added is accounted for by the edge growth term
THERMO.dV_max_edge = 2*FSTD.H_max*sum(FSTD.psi(:,end)./FSTD.R')*THERMO.drdt;

THERMO.dV_max_pancake = sum(THERMO.pancake_growth(:,end)/OPTS.dt_sub)*OPTS.h_p;

THERMO.V_max_in =  THERMO.dV_max_basal + THERMO.dV_max_adv + THERMO.dV_max_edge + THERMO.dV_max_pancake;

THERMO.V_max_out = 0;