function [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT]  = Set_Specific_Run_Variables(runnum,FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT) 

%% Which Processes Will Be Used?
OCEAN.DO = 0; % Whether or not to use the ocean model
MECH.DO = 0;
THERMO.DO = 0;
SWELL.DO = 0;
DIAG.DOPLOT = 0;
ADVECT.DO = 1; 
DIAG.DO = 1; 

%% Set Mechanics Options and External Forcing
MECH.simple_oc_sr = 1; % Use the inferred strain rate from the ocean
MECH.dont_guarantee_bigger = 1;
MECH.eps_I = 0;% -1e-7;
MECH.eps_II = 1e-7;

EXFORC.nu(1:OPTS.nt,1) = MECH.eps_I;
EXFORC.nu(1:OPTS.nt,2) = MECH.eps_II;
EXFORC.compressing = ones(1,OPTS.nt);

%% Initial Conditions
% Initial Distribution has all ice at one floe size. 
var = [2.5^2 .125^2];

% ps1 = mvnpdf([FSTD.meshR(:) FSTD.meshH(:)],[15 1.5],var);
psi = mvnpdf([FSTD.meshR(:) FSTD.meshH(:)],[25 1.1],var);
% psi = ps2/sum(ps2(:));
psi = reshape(psi,length(FSTD.R),length(FSTD.H)+1);
FSTD.psi = .9*psi/sum(psi(:));

ADVECT.FSTD_in = mvnpdf([FSTD.meshR(:) FSTD.meshH(:)],[15 1.5],var);
ADVECT.FSTD_in = ADVECT.FSTD_in / sum(ADVECT.FSTD_in(:)); 

%% Initialize all variables, keeping the options we have initialized
[FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT] = Initialize_FD(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT);