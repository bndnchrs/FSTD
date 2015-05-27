%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

Outname = {'SavedOutput/Full_Runs/FullModel_4D_Ridge', ...
    'SavedOutput/Full_Runs/ITDONLY', ...
    'SavedOutput/Full_Runs/FSDONLY', ...
    'SavedOutput/Full_Runs/AreaThickness', ...
    'SavedOutput/Full_Runs/HiblerThermo', ...
    'SavedOutput/Full_Runs/ThorndikeMech', ...
    'SavedOutput/Full_Runs/FSDONLY_NoSwell'
    };

numR = [50  1  50  1  1   1  50];
numH = [10 25   1  0  0  25   1];
DR =   [2  10  10 10 10  10  10];
DH =   [.1 .2   1  1  1   1   1];
HIB =  [0   0   0  0  1   0   0];
THORN =[0   0   0  0  0   1   0];
%%


% if doPAR == 1
%     
%     poolobj = gcp('nocreate');
%     if ~poolobj.Connected
%         parpool(2)
%     end
% end

for III = 1
    
    
    fprintf('Running Run %s \n',Outname{III})
    
    clearvars -except III Outname numH numR DR DH HIB THORN doPAR pool*
    
    %% Initialization
    
    do_Hibler = HIB(III);
    do_Thorndike = THORN(III);
    
    %%xlim([20 21] First initialize the main variables and overwrite main variables
    first_init = 1;
    
    D4_Ridging = 1; 
    
    use_old_interactions = 0; 
    dont_guarantee_bigger = 1;
    nt = 52*7*25*4; % 25 Years
  %  end_it = 1; 
    % nt = 1;
    %%
    dt = 3600*6; % 6 hours
   % nr = numR(III);
   % dr = DR(III);
   
   RR(1) = .5; 
   for i = 2:64
       RR(i) = sqrt(2*RR(i-1)^2 - (4/5) * RR(i-1)^2); 
   end
   
   %%
   R = RR; 

   nr = length(R); 
   dr = 2; 
   nh = 13;
   dh = .2;
   r_p = .5; 
    
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
    % nu = nu / 5;i
    
    % Fixed Compression
    nu = 0*nu + 1e-8;
    % nu(:,2) = 0*nu(:,2);
    
    
    %% Swell Forcing
    %   tau_swell = 1*day;
    
    % Get Storminess File
   % load('Swell/Storminess_Files/4weeksperyear')
    load('Swell/Storminess_Files/8weeksperyear')
    stormy(7,:) = stormy(6,:);
    Domainwidth = 50 * 1e3; 
    epscrit = .01;

    %% Initialize Distributions
    
    FSD = meshR.^(-2);
    ITD = lognpdf(meshH,-1,1);
    
    psi = ones(size(meshR)); 
%    psi = FSD.*ITD;
    psi(:,end) = 0;
    psi(end,:) = 0; 
    %psi(5,5) = 1; 
    
    
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
