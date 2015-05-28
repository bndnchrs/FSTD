function [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN]  = Set_Specific_Run_Variables(runnum,FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN) 

%% Which Processes Will Be Used?
OCEAN.DO = 1; % Whether or not to use the ocean model
MECH.DO = 0;
THERMO.DO = 1;
SWELL.DO = 1;
DIAG.DOPLOT = 0;
DIAG.DO = 1; 

%% Set Mechanics Options and External Forcing
MECH.dont_guarantee_bigger = 1;
MECH.eps_I = 0;% -1e-7;
MECH.eps_II = 1e-7;

EXFORC.nu(1:OPTS.nt,1) = MECH.eps_I;
EXFORC.nu(1:OPTS.nt,2) = MECH.eps_II;
EXFORC.compressing = ones(1,OPTS.nt);

%% Set Thermodynamics External Forcing

oner = zeros(1,168*2); 
oner(1:end) = 1; 
oner = 300*oner; 

EXFORC.QLW = 200 * ones(1,OPTS.nt);

EXFORC.QSW = repmat(oner,[1 OPTS.nt/336]); 
% EXFORC.QSW = 300 * ones(1,OPTS.nt); % * sin(2*pi*OPTS.time/OPTS.year);

%% Set Swell Fracture External Forcing

load('Input_Files/Storm_Files/Binary_Storms')

EXFORC.stormy = storms(runnum) + zeros(1,OPTS.nt);

SWELL.DO = storms(runnum); 

%% Initial Conditions
% Initial Distribution has all ice at one floe size. 
var = [2.5^2 125^2];

% ps1 = mvnpdf([FSTD.meshR(:) FSTD.meshH(:)],[15 1.5],var);
psi = mvnpdf([FSTD.meshR(:) FSTD.meshH(:)],[87.5 .3],var);
% psi = ps2/sum(ps2(:));
psi = reshape(psi,length(FSTD.R),length(FSTD.H)+1);
FSTD.psi = .9*psi/sum(psi(:));


%% Initialize all variables, keeping the options we have initialized
[FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = Initialize_FD(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN);