%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

Outnames = {'SavedOutput/Swell+Mech/SwellFirst','SavedOutput/Swell+Mech/MechFirst'};

stormy = zeros(2,2*7*24);

stormy(1,1:7*24) = 1; 
stormy(2,7*24+1:end) = 1; 
% stormy = [stormy fliplr(stormy)]; 

compressing = 1 - stormy; 

for III = 1:2
    
   
    fprintf('Run %d',III)
    
    clearvars -except III Outnames stormy compressing melting
    
    figure
    
       
    %% Initialization
    
    %% First initialize the main variables and overwrite main variables
    first_init = 1;
    
    nt = 2*7*24;
    dt = 3600;
    nr = 50;
    dr = 3;
    nh = 25;
    dh = .1;
    
    
    Initialize_FD;
    
    %% Overwrite Those Variables we want changed from modules
    
    var = [10^2 .125^2];
    
    ps1 = mvnpdf([meshR(:) meshH(:)],[6.5 1.5],var);
    ps2 = mvnpdf([meshR(:) meshH(:)],[87.5 .3],var);
    
    psi = ps1/sum(ps1(:))+ ps2/sum(ps1(:));
    
    
    psi = reshape(psi,length(R),length(H)+1);
    
    
    %%
    psi = .75*psi/sum(psi(:));
    
    
  %  tau_swell = 7*day;
    epscrit = .01;
    
    eps_I = -8e-7;
    eps_II = 0;
    
    nu = zeros(nt,2); 
    nu(:,1) = eps_I; 
    
    Q_surf = 250*ones(1,nt);
    % Q_surf = [Q_surf -Q_surf]; 
    
    Domainwidth = 5e3;
    
    %% Now initialize modules
    
    first_init = 0;
    
    do_FD = 1;

    do_Mech = 1; 
    do_Swell = 1; 
    do_Thermo = 1; 
    do_Plot = 1;
    do_Diagnostics = 1;
    
    Initialize_FD;
    
    
    %% Actually Run the Model
    
    driven = 1;
    
    %%
    
    pcolor(psi); 
    
    FD_Run;
    
    
    FD_Plot;
    
    
    save(Outnames{III},'-v7.3')
    
end