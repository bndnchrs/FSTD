%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

Outnames = {'SavedOutput/AnnDiurn/AnnDiurn_noql','SavedOutput/AnnDiurn/AnnOnly_noql',};

%%
rpvar = [.1 .25 .5 1 2 5 10 20];

% for i = 1:length(rpvar)
%     p = num2str(rpvar(i)); 
%     p(p=='.') = 'p';
%     
%     Outnames{i} = ['SavedOutput/AnnDiurn/Sens/RP' p]; 
% 
% end

%%

for III = 1:length(Outnames)
    
    Outname = Outnames{III};
    
    
    
    fprintf('Running Run %s \n',Outname)
    
    clearvars -except III Outname* numH numR DR DH HIB THORN doPAR pool* rpvar
    
    
    % frac_lead_sens = fls(III); 
    
    %%xlim([20 21] First initialize the main variables and overwrite main variables
    first_init = 1;
    
    params.qlmin = 0; 
    
    %end_it = 8506
    
    nt = 24*365*10; % 2 Years
    
    % nsst = 1;
    
    dt = 3600; % 1 hours
    
    % r_p = rpvar(III); 
    
    r_p = 1; 
    
 
    nh = 0;
    
    nr = 68;
    dr = 2;
  
   RR(1) = .5; 
   for i = 2:35
       RR(i) = sqrt(2*RR(i-1)^2 - (4/5) * RR(i-1)^2); 
   end
   
      R = 12:2:150;
   R = [RR R];
   nr = length(R); 
    r_p = .5;
    h_p = .1;
    
    
   % R = linspace(.5,.5 + (nr-1)*dr,nr);


    Initialize_FD;
    
    %% Overwrite Those Variables we want changed from modules
    
    
    %% Thermodynamic Forcing is read from Q_surf

    
    % 1 year of diurnal forcing, hourly spaced
    load('Thermodynamics/HeatingFiles/150diurnhourly.mat')
    
    load('Thermodynamics/HeatingFiles/300annualhourly.mat')
    
    nyears = round(time(end)/year);
    
    Q_diurn = repmat(Q_diurn,[1 nyears]);
    Q_surf  = repmat(Q_surf,[1 nyears]);
    
    Q_surf = Q_surf+Q_diurn*mod(III,2);
    
    %% Initialize Distributions
    
    FSD = meshR.^(-2);
    ITD = lognpdf(meshH,-1,1);
    
    
    psi = FSD.*ITD;
    % psi = 0*psi + 1;
    
    
    psi = 0*psi/sum(psi(:));
    openwater = 1 - sum(psi(:)); 
    
    H_max = .4 ;
    
    %% Now initialize modules
    
    first_init = 0;
    
    do_FD = 1;
    
    do_Mech = 0;
    
    do_Swell = 0;
    
    do_Thermo = 1;
    do_Plot = 1;
    do_Diagnostics = 1;
    
    if do_FD == 1
    
    Initialize_FD;
    
    end
    
    %% Actually Run the Model
    
    driven = 1;
    
    num_tasks = 1;
    
    do_FD = 1; 
    
    if do_FD == 1
    
    FD_Run;
    
    save(Outname,'-v7.3')
    
    else
     load(Outname)
    end
    
    % FD_PLOT_Sens;
    
    
    %%
    
end

