%% partition_heat_flux
% This routine partitions the incoming heat flux Q that is over open water
% into its components,
% some of which contribute to lateral melting, some to frazil formation,
% and some to thickness growth
[THERMO.Al,THERMO.Ao,THERMO.Alf] = calc_lead_area(FSTD.psi,FSTD.meshR,(1-FSTD.conc),OPTS.r_p);


% If the ocean is on, transmit heat from the ocean to the ice
if OCEAN.DO
    
    dens = OCEAN.EOS(OCEAN.T,OCEAN.S);
    OCEAN.Ti_Mean= integrate_FD(FSTD.psi,THERMO.T_ice,1);
    prefac = OCEAN.cp_w * dens;
    % Heat flux from ocean to ice
    OCEAN.Q_oi =  FSTD.conc* prefac * (OCEAN.T - OCEAN.Tfrz); 
    
    if OCEAN.no_oi_hf
        OCEAN.Q_oi = 0;
    end
    
end

THERMO.Q_o = THERMO.Ao*EXFORC.Q_oc; % Heat Flux to open water. 

% And if there is a heat flux from the ocean to the ice, remove it here
% from the over-water heat budget
if OCEAN.DO
    THERMO.Q_o = THERMO.Q_o - OCEAN.Q_oi; 
end

% if Ao < smallfrac && Q < 0 % Open a little tiny bit at all times
%    Ao = min(1-conc,smallfrac); % Either the open water or the smallest fraction, whichever smaller
%    Q_o = Ao*Q; % Heat Flux to open water
%    Al = 1 - conc - Ao; % The rest is lad fraction
% end

THERMO.Q_l = THERMO.Al*EXFORC.Q_oc; % Total Net Heat Flux to lateral/basal surface

if OCEAN.DO 
    THERMO.Q_l = THERMO.Q_l + OCEAN.Q_oi; 
end

THERMO.lbrat = (FSTD.SAmean/(FSTD.SAmean + FSTD.conc));


THERMO.Q_lat = THERMO.Q_l * THERMO.lbrat; 

if FSTD.conc < eps
    
    THERMO.Q_lat = THERMO.Q_l;
    THERMO.lbrat = 1; 
    
end

if FSTD.SAmean == Inf
    
    THERMO.Q_lat = 0;
    
end

% Q = Q_vert + Q_l + Q_o
% Q = Q_vert + Q_lat + Q_bas + Q_o

% THERMO.Q_vert = EXFORC.Q_oc - THERMO.Q_o - THERMO.Q_l; % Heat Flux to ice top
THERMO.Q_bas = THERMO.Q_l - THERMO.Q_lat;