function [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN]  = Set_Specific_Run_Variables(runnum,FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN) 

%% Which Processes Will Be Used?
OCEAN.DO = 1; % Whether or not to use the ocean model
MECH.DO = 1;

if OPTS.runnum > 4
    MECH.DO = 0; 
end

THERMO.DO = 1;
SWELL.DO = 0;
DIAG.DOPLOT = 0;
DIAG.DO = 1; 

%% Set Mechanics Options and External Forcing
MECH.simple_oc_sr = 1; % Use the inferred strain rate from the ocean
MECH.dont_guarantee_bigger = 1;
MECH.eps_I = 0;% -1e-7;
MECH.eps_II = 1e-7;

EXFORC.nu(1:OPTS.nt,1) = MECH.eps_I;
EXFORC.nu(1:OPTS.nt,2) = MECH.eps_II;
EXFORC.compressing = ones(1,OPTS.nt);

%% Set Thermodynamics External Forcing
oner = zeros(1,168*2); 
oner(1:end) = 1; 
oner = 250*oner; 

EXFORC.QLW = 100 * ones(1,OPTS.nt);

EXFORC.QSW = 0*repmat(oner,[1 ceil(OPTS.nt/336)]); 
% EXFORC.QSW = 300 * ones(1,OPTS.nt); % * sin(2*pi*OPTS.time/OPTS.year);

THERMO.mergefloes = mod(runnum,2); 

%% Set Ocean Forcing/Variables
OCEAN.T = -1.8; 
OCEAN.StrainInvar = zeros(2,OPTS.nt); 

% This is so we have conv, double conv, conv, no conv
OCEAN.StrainInvar(2,:) = 30e-5 * ceil(OPTS.numruns/2); 


%% Initial Conditions
% Initial Distribution has all ice at one floe size. 
% Initially has half ice concentration
var = [2.5^2 .125^2];

psi = mvnpdf([FSTD.meshR(:) FSTD.meshH(:)],[25 1.1],var);
psi = reshape(psi,length(FSTD.R),length(FSTD.H)+1);
FSTD.psi = .25*psi/sum(psi(:));


%% Initialize all variables, keeping the options we have initialized
[FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = Initialize_FD(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN);