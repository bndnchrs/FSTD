%% FD_initialize_diagnostics
% This code initializes all the diagnostics arrays that will be used in the
% execution of the FSD code

if do_FD == 1
    % Diagnostics for General Mode
    
    totnum = 0;
    psisave = zeros([size(psi) nt + 1]);
    psisave(:,:,1) = psi;
    concsave = 0*(1:nt);
    diffsave = 0*(1:nt);
    fulldiffsave = 0*psisave; 
    opensave = 0*(1:nt);
    open0save = 0*(1:nt);
    Rmeanarea = 0*(1:nt);
    Rmeannum = 0*(1:nt);
    HMSAVE = concsave;
    VMISAVE = concsave;
    %    AISAVE(i) = dA_max;
    Volex = concsave;
    TotVol = concsave;
    %     VSAVE_MAX(i) = Vol_diff;
    dhdtsave = concsave;
    dhdtvolsave = concsave;
    dhdtinpsave = concsave;
    
    smallfloes = 0*(1:nt);
    smallmfs = 0*(1:nt);
    bigmfs = 0*(1:nt);
    bigfloes = 0*(1:nt);
    gamsave = 0*(1:nt);
    
    VSAVE =0*(1:nt);
    VMSAVE= VSAVE ; 
    HSAVE = 0*(1:nt);
    OWSAVE = 0*(1:nt);
    
end

if do_Mech == 1
    % Diagnostics for Mechanical Mode
    work2div = 0*(1:nt);
    ridgework = 0*(1:nt);
    raftwork = 0*(1:nt);
    magsave = 0*(1:nt);
    openersave = 0*(1:nt);
    divsave = 0*(1:nt);
    eps2save = 0*(1:nt);
    THETASAVE = 0*(1:nt);
    PSAVE = 0*(1:nt);
    fulldiffmech = 0*psisave; 
    
end

if do_Thermo == 1
    % Diagnostics for Thermodynamic Mode
    
    fulldiffthermo = 0*psisave; 
    
    % Side growth rate
    drdtsave = 0*(1:nt);
    % Thickness growth rates at each floe thickness
    dhdtsave = zeros(length(H)+1,nt);
    % Ocean temperature
    Tsave = 0*(1:nt);
    % Heat fluxes saved
    Qsave = zeros(nt,3);
    % Total Surface area
    SAsave = 0*(1:nt);
    % Lead fraction
    Alsave = 0*(1:nt);
    % Edge-growth
    EGsave = 0*(1:nt);
    % Basal Heat Flux
    bashf = 0*(1:nt);
    % Surface Heat Flux
    surfhf = 0*(1:nt);
    
    dtmin = 0*psisave; 
    dtplus = 0*psisave; 
    
    % Pancake Growth
    pansave = 0*(1:nt); 
    
end

if do_Swell == 1
    fulldiffswell = 0*psisave; 
    wattensave(:,i) = 0*R; 
    tauswellsave(:,i) = 0*R; 
end

