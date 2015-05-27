%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

Outnames = {'SavedOutput/Freezeup/Gen_FSD'},
   
%%

for III = 1:length(Outnames)
    
    
    
    fprintf('Run %d',III)
    
    clearvars -except III Outnames melting
    
    figure
    
    
    %% Initialization
    
    %% First initialize the main variables and overwrite main variables
    first_init = 1;
    
    nt = 24*2*30;
    
    
    
    dt = 3600;
    nr = 50;
    dr = 5;
    nh = 13;
    dh = .2;
    
    Initialize_FD;
    
    %% Overwrite Those Variables we want changed from modules
  
    psi = zeros(length(R),length(H)+1); 

    Q_surf = -2p00*ones(length(time),1); 
    
    %% Now initialize modules
    
    first_init = 0;
    
    do_FD = 1;
    
    do_Mech = 0;
    do_Swell = 0;
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
    else
        
        FD_Run;
    end
    
    if do_FD == 1
        
        save(Outnames{III},'-v7.3')
    end
    
%    PLOT_FSD_ONLY_Swell_Frac(Outnames{III},0);
    
    
end