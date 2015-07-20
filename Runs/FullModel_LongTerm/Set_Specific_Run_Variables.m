function [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN]  = Set_Specific_Run_Variables(runnum,FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN) 
%% This function sets the run-specific variables, for run number runnum

%% Which Processes Will Be Used?
OCEAN.DO = 1; % Whether or not to use the ocean model
MECH.DO = 0;
THERMO.DO = 1;
SWELL.DO = 1;
DIAG.DOPLOT = 0;
DIAG.DO = 1; 

%% Set Mechanics Options and External Forcing
MECH.simple_oc_sr = 1; % Use the inferred strain rate from the ocean
MECH.dont_guarantee_bigger = 1;
MECH.eps_I = 1e-7;% -1e-7;
MECH.eps_II = 1e-7;

EXFORC.nu(1:OPTS.nt,1) = MECH.eps_I;
EXFORC.nu(1:OPTS.nt,2) = MECH.eps_II;
EXFORC.compressing = ones(1,OPTS.nt);

%% Set Thermodynamics External Forcing
oner = zeros(1,168*2); 
oner(1:end) = 1; 
oner = 250*oner; 

% Weak heating, leads to ice formation rapidly
EXFORC.QLW = 200 * ones(1,OPTS.nt);

if length(FSTD.time) > 52*7*4
    
    EXFORC.QSW = 500*sin(2*pi*FSTD.time(1:52*7*4)/OPTS.year);
    
    EXFORC.QSW = repmat(EXFORC.QSW,[1 ceil(OPTS.nt/(52*7*4))]); 

else
        
    EXFORC.QSW = 400*sin(2*pi*FSTD.time(1:end)/OPTS.year);
end
    
EXFORC.QSW(EXFORC.QSW < 0) = 0; 


% nyears = round(time(end)/year);
% Q_surf  = repmat(Q_surf,[1 nyears]);
% Merge, no, merge, no, etc
THERMO.mergefloes = runnum - 1; 

%% Set Wave Forcing/Variables

SWELL.prescribe_spec = 0; 
EXFORC.stormy = zeros(1,52*7); 
EXFORC.stormy(1:28*4) = 1; 
EXFORC.stormy = repmat(EXFORC.stormy,[1 4*ceil(OPTS.nt/(52*7*4))]);


EXFORC.QSW = repmat(EXFORC.QSW,[1 ceil(OPTS.nt/(52*7*4))]); 

SWELL.DO = 1; 


OPTS.Domainwidth = 1e3; 



%% Set Ocean Forcing/Variables

% Ocean at its freezing point
OCEAN.T = -1.8; 
% Only shearing
OCEAN.StrainInvar = zeros(2,OPTS.nt); 
OCEAN.lambda_ll = 365*86400; 
% Always shearing, nothing else
OCEAN.StrainInvar(2,:) = 30e-5; %* ceil(runnum/2); 


%% Initial Conditions
% Initial Distribution has all ice ~ at one floe size and thickness. 
% Initially has 1/4 ice concentration
var = [2.5^2 .125^2];

psi = mvnpdf([FSTD.meshR(:) FSTD.meshH(:)],[25 1.1],var);
psi = reshape(psi,length(FSTD.R),length(FSTD.H)+1);
FSTD.psi = 0*psi/sum(psi(:));


%% Initialize all variables, keeping the options we have initialized
[FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = Initialize_FD(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN);