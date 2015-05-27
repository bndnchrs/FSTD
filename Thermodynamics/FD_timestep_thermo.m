%% FD_timestep_thermo
% This routing calculates the tendency due to one thermodynamic timestep

% Calculate total floe surface area per sea surface area
[meshRthermo,~] = meshgrid([r_p R(2:end)],[H H_max]);

% This is the total floe surface area, mean
SAmean = integrate_FD(psi,2*bsxfun(@rdivide,[H H_max],R'),1);
% If it is zero, we set it to be infinite
if SAmean == 0;
    SAmean = Inf;
end

% Determine what portion of the heat flux goes where
partition_heat_flux;
% Returns
% Q_vert - Heat flux that is over ice
% Q_bas - heat flux to lead region that goes to ice base
% Q_lat - heat flux to lead region that goes to ice sides
% Q_l - heat flux to lead region (total = Q_bas + Q_lat). 
% Q_o - heat flux to open water

%% Pancake Growth
if Q_o < 0 % Freezing ice
    pancakes = -Q_o / (L_f * rho_ice * h_p);
else
    pancakes = 0;
end
pancake_growth = 0*meshR;
pancake_growth(1,1) = pancakes*dt_sub;

%% Floe Size Growth Rate
% Growth at each floe size. 
if Q > 0 % Some small area is open to heat fom the atmosphere
    
    if exist('params','var') && params.qlmin == 0; 
    Al = max(Al,smallfrac);
    Q_l = Q*Al;
    Q_lat = Q_l * (SAmean/(SAmean + conc));
    
    if conc < eps
        
        Q_lat = Q_l;
        
    end
    
    if SAmean == Inf
        
        Q_lat = 0;
        
    end
    
    Q_vert = Q - Q_o - Q_l; % Heat Flux to ice top
    Q_bas = Q_l - Q_lat;
    
    end
    
end

drdt = -Q_lat/(rho_ice*L_f*(SAmean));
edgegrowth = dt_sub*(2./meshR).*psi*drdt;



%% Thickness Growth Rate 

% dhdt_surf = -.1*Q_vert/(rho_ice*L_f);
% dhdt_bas = -Q_bas/(rho_ice*L_f);

if conc == 0
    dhdt_bas = 0;
end

% deltaT = 0; 
if exist('do_diff','var') && do_diff == 1
dhdt_diff = kice*deltaT./(rho_ice*L_f*[H H_max]);
else
    dhdt_diff = 0 + 0*[H H_max]; 
end

dhdt = (dhdt_surf + dhdt_bas + dhdt_diff);




%% Advective Tendencies
v_r = repmat(drdt,size(psi));
v_h = repmat(dhdt,[length(R),1]);

adv_tend = advect2_upwind(psi,R,[H H_max],v_r,v_h,dt_sub);

if(isnan(sum(adv_tend(:))))
    
    error('isnan advtend');

end

%%
clear v_r v_h

diff_thermo = (1/dt_sub) * (adv_tend + pancake_growth + edgegrowth);

%%
opening_thermo = -sum(diff_thermo(:));

if Q < 0
    % If we are freezing, the amount of ice volume added is equal to the
    % incoming ice multiplied by that ice's thickness
    if ~isempty(H)
    dV_max_adv = sum(adv_tend(:,end)*H(end))/dt_sub;
    else
        % There is no advective flux between thickness classes as there are no
        % thickness classes
        dV_max_adv = 0; 
    end
    
else
    % Otherwise it is equal to the lost ice volume at the largest size
    if ~isempty(H)
    dV_max_adv = sum(adv_tend(:,end)*H_max)/dt_sub;
    else
        % again, no advective flux because there are no thickness classes
        dV_max_adv = 0;
    end
end

% Added volume is equal to dhdt * psi(r,h_max)
dV_max_basal = sum(psi(:,end)*dhdt(:,end)); 

% The actual ice added is accounted for by the edge growth term
dV_max_edge = 2*H_max*sum(psi(:,end)./R')*drdt;

dV_max_pancake = sum(pancake_growth(:,end)/dt_sub)*h_p; 

V_max_in_thermo =  dV_max_basal + dV_max_adv + dV_max_edge + dV_max_pancake;

V_max_out_thermo = 0;


