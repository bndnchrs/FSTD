function [diff,dhdt,opening,pancake_growth] = do_timestep_thermo(n,H,R,openwater,conc,Q,dt,h_p)
% Some constants
rho_ice = 934;
L_f = 334000;
smallfrac = .05; 

T_melt = -1.96; % Freezing point of sea-water
T_i = 0; % Ice internal temperature

% Find lateral surface area
SAmean = integrate_FD(n,2*H./R,1);

% If surface area is zero, we don't use it.
if SAmean == 0;
    SAmean = Inf;
end

% Calculating the lead area of the floes
[Al,Ao,Alf] = calcLeadArea(n,R,openwater);

% Getting the local variables
Q_l = Al*Q;
Q_o = Ao*Q;
Q_lat = Q_l*(SAmean/(SAmean + conc));
if conc == 0
    Q_lat = Q_l; 
end
% Vertical heat flux
Q_vert = Q - Q_o - Q_lat;
Q_bas = Q_lat * (conc / (SAmean * conc));
%   Q_vert = .1*Q_vert;


%% Calculating  drdt
drdt = -Q_lat/(rho_ice*L_f*SAmean);


%%
% For this simple version, dhdt is an expression of the surface heat
% budget

if H ~= 0
    dhdt = -.1*Q / (rho_ice * L_f * H);
else
    dhdt = 0; 
end

% Growth in open water regions in the form of pancakes
if Q_o < 0 % Freezing ice
    pancakes = -Q_o / (L_f * rho_ice * h_p);
else
    pancakes = 0;
end

pancake_growth = 0*R;
pancake_growth(1) = pancakes;


% Growth just per floe size
diff_edge = (2./R).*n*drdt;

if Q > 0 % Some small area is open to heat fom the atmosphere
    Al = max(Al,smallfrac);
    %    Al = min(Al,sum(n));
    Q_l = Al*Q;
    Q_lat = Q_l*(SAmean/(SAmean + conc));
    if conc == 0
        Q_lat = Q_l; 
    end
    drdte = -(Q_lat)/(rho_ice*L_f*(SAmean));
    diff_edge = (2./R).*n*drdte;
end

% Advecting due to increase in floe sizes
% Advection is supplemented by the freezing of leads due to the excess
% energy on the floes
diff_adv = advect(n,drdt,dt,R,R(2)-R(1));

%%
diff =  diff_adv + diff_edge + pancake_growth; %dt*leadfreezing;

opening = - sum(diff_adv) - sum(diff_edge) - sum(pancake_growth);

end