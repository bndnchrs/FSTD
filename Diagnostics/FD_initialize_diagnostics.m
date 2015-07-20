%% FD_initialize_diagnostics
% This code initializes all the diagnostics arrays that will be used in the
% execution of the FSD code

nt = OPTS.nt; 

if FSTD.DO
    % Diagnostics for General Mode
    
    DIAG.totnum = 0;
    DIAG.psi = zeros([size(FSTD.psi) nt + 1]);
    DIAG.psi(:,:,1) = FSTD.psi;
    DIAG.conc = 0*(1:nt);
    DIAG.diff = 0*(1:nt);
    DIAG.fulldiff = 0*DIAG.psi; 
    DIAG.opensave = 0*(1:nt);
    DIAG.open0save = 0*(1:nt);
    DIAG.Rmeanarea = 0*(1:nt);
    DIAG.Rmeannum = 0*(1:nt);
    DIAG.H =0*(1:nt);
    DIAG.V_max_in = 0*(1:nt);
    %    AISAVE(i) = dA_max;
    DIAG.V_max = 0*(1:nt);
    DIAG.V_less = 0*(1:nt);
    DIAG.V_tot = 0*(1:nt); 
    DIAG.Vmax = 0*(1:nt);
    %     VSAVE_MAX(i) = Vol_diff;
    DIAG.dhdt = 0*(1:nt);
    DIAG.dhdtvol = 0*(1:nt);
    DIAG.dhdtinp = 0*(1:nt);
    DIAG.gamma = 0*(1:nt);
    
end

if MECH.DO == 1
    % Diagnostics for Mechanical Mode
    DIAG.work2div = 0*(1:nt);
    DIAG.ridgework = 0*(1:nt);
    DIAG.raftwork = 0*(1:nt);
    DIAG.mag = 0*(1:nt);
    DIAG.opener = 0*(1:nt);
    DIAG.div = 0*(1:nt);
    DIAG.eps2 = 0*(1:nt);
    DIAG.THETA = 0*(1:nt);
    DIAG.P = 0*(1:nt);
    DIAG.fulldiffmech = 0*DIAG.psi; 
 
    if MECH.simple_oc_sr
        DIAG.ocicfac = 0*(1:nt); 
    end
    
end

if THERMO.DO == 1
    % Diagnostics for Thermodynamic Mode
    
    DIAG.T_ice = zeros(length(FSTD.H)+1,nt);
    DIAG.fulldiffthermo = 0*DIAG.psi; 
    % Side growth rate
    DIAG.drdt = 0*(1:nt);
    % Thickness growth rates at each floe thickness
    DIAG.dhdt = zeros(length(FSTD.H)+1,nt);
    % Ocean temperature
    DIAG.Toc = 0*(1:nt);
    % Heat fluxes saved
    DIAG.Qpartition = zeros(nt,3);
    % 1st column is to bases
    % 2nd column is to sides
    % 3rd column is open water
    
    % Total Surface area
    DIAG.SA = 0*(1:nt);
    % Lead fraction
    DIAG.Al = 0*(1:nt);
    DIAG.Ao = 0*(1:nt);
    % Edge-growth
    DIAG.EGsave = 0*(1:nt);
    % Basal Heat Flux
    
    % Pancake Growth
    DIAG.pansave = 0*(1:nt); 
    
end

if SWELL.DO
    DIAG.fulldiffswell = 0*DIAG.psi; 
    DIAG.wattensave = zeros(length(FSTD.R),nt); 
    DIAG.tauswellsave = zeros(length(FSTD.R),nt);  
end

if OCEAN.DO
    DIAG.OceanT = 0*(1:nt); 
    DIAG.OceanS = 0*(1:nt); 
    DIAG.OceanQo = 0*(1:nt); 
    DIAG.OCEANQoi = 0*(1:nt); 
    DIAG.Oceanpan = 0*(1:nt); 
    DIAG.OceandTdt = 0*(1:nt); 
    DIAG.OCELW = 0*(1:nt); 
    DIAG.OCESW = 0*(1:nt); 
    DIAG.OCESH = 0*(1:nt); 
    DIAG.OCERELAX = 0*(1:nt); 
end
    
