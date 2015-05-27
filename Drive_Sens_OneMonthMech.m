%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

Outname = {'SavedOutput/OneMonthmech/Sens/1f_Noinc_dr2', ...
    'SavedOutput/OneMonthmech/Sens/1f_NoincR_dr4', ...
 %   'SavedOutput/OneMonthmech/Sens/1f_incR_dr2', ...
 %   'SavedOutput/OneMonthmech/Sens/1f_incR_dr4', ...
 %   'SavedOutput/OneMonthmech/Sens/1f_incboth_dr2', ...
 %   'SavedOutput/OneMonthmech/Sens/1f_incboth_dr4' ...
    };

strainname = {'_Conv','_Shear'};

numR = [75 23 45 23 45 23];
numH = [13 13 13 13 13 13];
DR =   [2  4   2  4  2  4];
DH =   [.2 .2 .2 .2 .2 .2];
dgb=   [1  1   0  0  0  0];
usi=   [0  0   0  0  1  1];


% Convergence or shear
EPS = 1*[-1e-7 0; 0 -1e-7];

%%

for strainstate = 1:1
    
    for III = 1:6
        
        outname = [Outname{III} strainname{strainstate}];
        
        fprintf('Running Run %s \n',outname)
        
        clearvars -except III usi Outname* strain* outname numH numR DR DH EPS dgb*
        
        %% Initialization
        
        %%xlim([20 21] First initialize the main variables and overwrite main variables
        first_init = 1;
        
        dont_guarantee_bigger = dgb(III);
        use_old_interactions = usi(III); 
        nt = 12*30;
        % nt = 6; 
        
        dont_rescale_eps = 1;
        
        
        dt = 2*3600;
        nr = numR(III);
        dr = DR(III);
        nh = numH(III);
        dh = DH(III);
        
        R = 1:dr:150;
        H = .1:dh:2.5;
        r_p = .5;
        h_p = .3;
        
        Initialize_FD;
        
        %% Overwrite Those Variables we want changed from modules
        
        
        %% Mechanical Forcing Done Seperately
        epscrit = .01;
        
        % Always have mechanics on
        compressing = ones(length(Outname),nt);
        % Get eps_I and eps_II
        load('Mechanics/Compression_Files/4hre-8rw25yrs');
        % nu = nu / 5;
        
        % Fixed Compression
        nu = bsxfun(@plus,0*nu,EPS(strainstate,:));
        % nu(:,2) = 0*nu(:,2);
        
        %% Overwrite Those Variables we want changed from modules
        
        var = [5^2 .125^2];
        
        ps1 = mvnpdf([meshR(:) meshH(:)],[15 1.5],var);
        ps2 = mvnpdf([meshR(:) meshH(:)],[90 .25],var);
        
        psi = ps1/sum(ps1(:))+ ps2/sum(ps1(:));
        
   %     psi = 0*psi;
        
        
        psi = reshape(psi,length(R),length(H)+1);
        
    %    psi(15,1) = 1; 

        
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
        num_tasks = do_Thermo + do_Swell + do_Mech;
        
        %%
        FD_Run;
        
        
        FD_Plot;
        
        %%
        save(outname,'-v7.3')
        
    end
    
end
