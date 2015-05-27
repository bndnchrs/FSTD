%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

Outnames = {'SavedOutput/OneWeekmech/Compressing','SavedOutput/OneWeekmech/Shear'}

EPS = [-1e-7 0; 0 -1e-7];
compressing = ones(2,12*30); 
dont_rescale_eps = 1; 

%%
for III = 1:length(Outnames)
    
    
    fprintf('Run %d',III)
    
    clearvars -except III Outnames stormy compressing melting EPS dont_rescale_eps
    
    figure
    
    
    %% Initialization
    
    %% First initialize the main variables and overwrite main variables
    first_init = 1;
    
    nt = 12*30;
    dt = 7200;
    nr = 25;
    dr = 6;
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
    
    
    tau_swell = 7*day;
    epscrit = .01;
    
    eps_I = EPS(1,III);
    eps_II = EPS(2,III);


    nu(1:nt,1) = eps_I;
    nu(1:nt,2) = eps_II;
    
    Q_surf = 250*ones(1,nt/2);
    Q_surf = [Q_surf -Q_surf];
    
    %% Now initialize modules
    
    first_init = 0;
    
    do_FD = 1;
    
    do_Mech = 1;
    do_Swell = 0;
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
    end
    
    FD_Run;
    
    
    if do_FD == 1
        
        save(Outnames{III},'-v7.3')
    end
    
    FD_Plot;
    
    
end

%%
PLOT_Singleweek_Mech_Runs;