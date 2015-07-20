%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

%%


for III = 1
    
    
    fprintf('Running Run %s \n',Outname{III})
    
    clearvars -except III Outname numH numR DR DH HIB THORN doPAR pool*
    
    %% Initialization
    
 
    
  
    Initialize_FD;
    
    %% Overwrite Those Variables we want changed from modules
    
    
    %% Thermodynamic Forcing is read from Q_surf
    %Q_surf = -300*sin(2*pi*(time)/ (year)); % Ocean surface heat flux
    %Q_diurn = 0*150*cos(2*pi*time/(day));
    
    % Net is zero after 1 year
    load('Thermodynamics/HeatingFiles/300annual');
    
    Q_surf = (250/300)*Q_surf; 
    
    nyears = round(time(end)/year);
   
    Q_surf  = repmat(Q_surf,[1 nyears]);
   

    
    %% Mechanical Forcing Done Seperately
    % Always have mechanics on
    compressing = ones(length(Outname),nt);
    % Get eps_I and eps_II
    load('Mechanics/Compression_Files/4hre-8rw25yrs');
    % nu = nu / 5;
    
    % Fixed Compression
    nu = 0*nu + 1e-8;
    % nu(:,2) = 0*nu(:,2);
    
    
    %% Swell Forcing
    %   tau_swell = 1*day;
    
    % Get Storminess File
   % load('Swell/Storminess_Files/4weeksperyear')
    load('Swell/Storminess_Files/8weeksperyear')
    stormy(7,:) = stormy(6,:);
    
    %% Initialize Distributions
    
    FSD = meshR.^(-2);
    ITD = lognpdf(meshH,-1,1);
    
    
    psi = FSD.*ITD;
    psi(:,end) = 0;
    psi(end,:) = 0; 
%    psi(5,5) = 1; 
    
    
    psi = psi/sum(psi(:));
    
    
    H_max = max(H) + dh ;
    
    %% Now initialize modules
    
    first_init = 0;
    
    do_FD = 1;
    
    do_Mech = 1;
    
    do_Swell = 1;
    
    if III == 7
        do_Swell = 0;
    end
    
    if nr < 2
        do_Swell = 0;
    end
    
    
    do_Thermo = 1;
    do_Plot = 1;
    do_Diagnostics = 1;
    
    Initialize_FD;
    
    
    %% Actually Run the Model
    
    driven = 1;
    
    num_tasks = do_Thermo + do_Swell + do_Mech;
    
    
    FD_Run;
    
    
    FD_Plot;
    
    
    %%
    
    save(Outname{III},'-v7.3')
    
end
