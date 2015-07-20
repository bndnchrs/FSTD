%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

Outnames = {'SavedOutput/OneWeekMech/New_Out_Conv', ...
    'SavedOutput/OneWeekMech/New_Out_Shear'};
    


%%
stormy(1:5,1:120*24) = 1;
% stormy(2,7*30+1:end) = 1;
% stormy = [stormy fliplr(stormy)];



thicks = [25 50 100 200 250]


compressing = 1 - stormy;

compressing = ones(2,max(size(stormy)));

EPS = 1*[-1e-7 0; 0 -1e-7];

%%

for III = 1:1
    
    
    
    fprintf('Run %d',III)
    
    clearvars -except III Outnames stormy thicks compressing melting EPS

    
    polyfitter = 2; 
    
    %% Initialization
    
    %% First initialize the main variables and overwrite main variables
    first_init = 1;
    
    nt = 24*30;
    
    epscrit = .1;
    
    % stormy = ones(5,nt);
    % start_it = nt/2;
    
    dont_rescale_eps = 1; 
    dt = 3600;
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
    
    
 %   R = linspace(r,dr + (nr-1)*dr,nr);

 %   psi(30,16) = 1; 
    
    %%
    psi = .75*psi/sum(psi(:));
    
    
    %    tau_swell = 7*day;
   % epscrit = .01;
    
      eps_I = EPS(1,III);
      eps_II = EPS(2,III);
    
   % eps_I = -1e-7;
   % eps_II = 0; 
  %  eps_II = 1e-7;
    
    nu(1:nt,1) = eps_I;
    nu(1:nt,2) = eps_II;
    
   % Q_surf = 250*ones(1,nt/2);
   % Q_surf = [Q_surf -Q_surf];
    
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
    else
        
        FD_Run;
    end
    
    if do_FD == 1
        
        save(Outnames{III},'-v7.3')
    end
    
%    PLOT_FSD_ONLY_Swell_Frac(Outnames{III},0);
    
    
end