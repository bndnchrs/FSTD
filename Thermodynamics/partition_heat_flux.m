%% partition_heat_flux
% This routine partitions the incoming heat flux Q into its components,
% some of which contribute to lateral melting, some to frazil formation,
% and some to thickness growth

[Al,Ao,Alf] = calc_lead_area(psi,meshR,openwater,r_p);

% For Sensitivity Analysis
if exist('frac_lead_sens','var')
    Al = frac_lead_sens * openwater;
    Ao = openwater - Al;
end
% Eliminate later
Q_o = Ao*Q; % Heat Flux to open water

% if Ao < smallfrac && Q < 0 % Open a little tiny bit at all times
%    Ao = min(1-conc,smallfrac); % Either the open water or the smallest fraction, whichever smaller
%    Q_o = Ao*Q; % Heat Flux to open water
%    Al = 1 - conc - Ao; % The rest is lad fraction
% end

Q_l = Al*Q; % Heat Flux to lateral surface

Q_lat = Q_l * (SAmean/(SAmean + conc));

if conc < eps
    
    Q_lat = Q_l;
    
end

if SAmean == Inf
    
    Q_lat = 0;
    
end

% Q = Q_vert + Q_l + Q_o
% Q = Q_vert + Q_lat + Q_bas + Q_o

[dhdt,Q_cond,Q_atm,T_new] = semtner_1D_thermo(Q,h,T_0);


Q_vert = Q - Q_o - Q_l; % Heat Flux to ice top
Q_bas = Q_l - Q_lat; % Heat Flux to ice base
