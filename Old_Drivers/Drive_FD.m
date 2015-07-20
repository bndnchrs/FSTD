%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

Outnames = {'SavedOutput/OneStep/Run'}

stormy = zeros(1,1);
stormy = 1; 

compressing = 1;

III = 1; 
    
    
    fprintf('Run %d',III)
    
    clearvars -except III Outnames stormy compressing melting EPS
    
    figure
    
    
    %% Initialization
    
    %% First initialize the main variables and overwrite main variables
    first_init = 1;
    
    nt = 1;
    dt = 7200;
    nr = 50;
    dr = 3;
    nh = 25;
    dh = .1;
    
    
    Initialize_FD;
    
    %% Overwrite Those Variables we want changed from modules
    
    var = [5^2 .125^2];
    
    ps1 = mvnpdf([meshR(:) meshH(:)],[6.5 1.5],var);
    ps2 = mvnpdf([meshR(:) meshH(:)],[87.5 .3],var);
    
    psi = ps1/sum(ps1(:))+ ps2/sum(ps1(:));
    
    
    psi = reshape(psi,length(R),length(H)+1);
    
    
    %%
    psi = .5*psi/sum(psi(:));
    
    
    tau_swell = 100*day;
    epscrit = .01;
    
    eps_I = 0;% -1e-7;
    eps_II = 1e-7;
    
    nu(1:nt,1) = eps_I;
    nu(1:nt,2) = eps_II;
    
    Q_surf = -100;
    
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
    
    % If we just want to plot the output, set this to 0
    do_FD = 1;
    
    if do_FD == 0
        
        load(Outnames{III});
    end
    
    FD_Run;
    
    
    if do_FD == 1
        
        save(Outnames{III},'-v7.3')
    end
 
    PLOT_TSTEP_PCOLOR
    
%    FD_Plot;
   