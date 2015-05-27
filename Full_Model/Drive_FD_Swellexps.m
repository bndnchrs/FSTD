%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

Outnames = {'SavedOutput/OneWeekSwell/1w16h150r1spec' };
    
 %   'SavedOutput/OneWeekSwell/Sens/lookup',...
 %   'SavedOutput/OneWeekSwell/Sens/1week250'}


%%
stormy(1:5,1:120*24) = 1;
% stormy(2,7*30+1:end) = 1;
% stormy = [stormy fliplr(stormy)];

thicks = [25 50 100 200 250]


compressing = 1 - stormy;

compressing = ones(2,max(size(stormy)));

EPS = 10*[-1e-7 0; 0 -1e-7];

%%

for III = 1:length(Outnames)
    
    
    
    fprintf('Run %d',III)
    
    clearvars -except III Outnames stormy thicks compressing melting EPS
    
    figure
    
    polyfitter = 2; 
    
    %% Initialization
    
    %% First initialize the main variables and overwrite main variables
    first_init = 1;
    
    nt = 24*7*2;
    
    epscrit = .1;
    
    stormy = ones(5,nt);
    % start_it = nt/2;
    
    
    dt = 3600;
    nr = 50;
    dr = 5;
    nh = 25;
    dh = .1;
    
    Initialize_FD;
    
    %% Overwrite Those Variables we want changed from modules
    
    var = [.1 + 0*10^2 .125^2];
    ps1 = mvnpdf([meshR(:) meshH(:)],[6.5 1.5],var);
    ps2 = mvnpdf([meshR(:) meshH(:)],[87.5 2.5],var);
    
    psi = 0*ps1/sum(ps1(:))+ ps2/sum(ps2(:));
    psi = 0*psi; 
    
    Domainwidth = 5e1*1e3;
    
    psi = reshape(psi,length(R),length(H)+1);
    psi = psi * 0; 
    psi(30,16) = 1; 
    
    %%
    psi = .75*psi/sum(psi(:));
    
    
    %    tau_swell = 7*day;
    epscrit = .01;
    
    %  eps_I = EPS(1,III);
    %  eps_II = EPS(2,III);
    
    eps_I = 0;
    eps_II = 1e-7;
    
    nu(1:nt,1) = eps_I;
    nu(1:nt,2) = eps_II;
    
   % Q_surf = 250*ones(1,nt/2);
   % Q_surf = [Q_surf -Q_surf];
    
    %% Now initialize modules
    
    first_init = 0;
    
    do_FD = 1;
    
    do_Mech = 0;
    do_Swell = 1;
    do_Thermo = 0;
    do_Plot = 1;
    do_Diagnostics = 1;
    
    Initialize_FD;
    
    
    %% Actually Run the Model
    
    driven = 1;
    
    % If we just want to plot the output, set this to 0
    do_FD = 1;
    
    if do_FD == 0
        
        load(Outnames{III});
    else
        
        FD_Run;
    end
    
    if do_FD == 1
        
        save(Outnames{III},'-v7.3')
    end
    
    PLOT_FSD_ONLY_Swell_Frac(Outnames{III},0);
    
    
end