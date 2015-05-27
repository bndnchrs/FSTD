function Set_Run_Variables

global OPTS
global FSTD
global THERMO
global MECH
global SWELL
global DIAG
global EXFORC
global OCEAN




%% Set General options

OPTS.NAMES = {'SavedOutput/OneStep/Run'};
OPTS.run_number = 1;
OPTS.nt = 24*60; % Number of timesteps
OPTS.dt = 3600; % Timestep duration
OPTS.dr = 2; % Size increment
OPTS.nh = 13; % No. thickness categories
OPTS.dh = .2; % Thickness increment


OPTS.time = linspace(OPTS.dt,OPTS.nt*OPTS.dt,OPTS.nt); 

% Initial discretization
RR(1) = .5;
for i = 2:64
    RR(i) = sqrt(2*RR(i-1)^2 - (4/5) * RR(i-1)^2);
end
OPTS.nr = length(RR); % Number of size categories
FSTD.R = RR;
OPTS.r_p = .5; % Minimum floe size category
OPTS.h_p = .1; % Minimum thickness category
clear RR
FSTD.H = .1:OPTS.dh:2.5;

%% Just get the basic fields we need
OPTS.first_init = 1;
Initialize_FD; 


%% Which Processes Will Be Used?

OCEAN.DO = 1; % Whether or not to use the ocean model
MECH.DO = 0;
THERMO.DO = 1;
SWELL.DO = 1;
DIAG.DOPLOT = 0;
DIAG.DO = 1; 



%% Set Mechanics Options
MECH.dont_guarantee_bigger = 1;
MECH.eps_I = 0;% -1e-7;
MECH.eps_II = 1e-7;

EXFORC.nu(1:OPTS.nt,1) = MECH.eps_I;
EXFORC.nu(1:OPTS.nt,2) = MECH.eps_II;
EXFORC.compressing = ones(1,OPTS.nt);
%% Set Thermodynamics Options
EXFORC.QLW = 200 *ones(1,OPTS.nt);
EXFORC.QSW = 300 * ones(1,OPTS.nt); % * sin(2*pi*OPTS.time/OPTS.year);
% EXFORC.QSW(EXFORC.QSW < 0) = 0; 
THERMO.allow_adv_loss_H = 1; % Allow for loss of ice through decreasing thickness
THERMO.allow_adv_loss_R = 0;

OPTS.SHLambda = 1/100; 


%% Set Swell Fracture Options

OPTS.Domainwidth = 5e4;
EXFORC.stormy = 1 + zeros(1,OPTS.nt);
SWELL.epscrit = .01;

%% Set Ocean Options
OCEAN.taui = 86400; 
OCEAN.no_oi_hf = 0; 
OCEAN.H = 50; 
%% Initial Conditions

var = [2.5^2 .125^2];

ps1 = mvnpdf([FSTD.meshR(:) FSTD.meshH(:)],[15 1.5],var);
ps2 = mvnpdf([FSTD.meshR(:) FSTD.meshH(:)],[87.5 .3],var);

psi = ps1/sum(ps1(:))+ ps2/sum(ps1(:));


psi = reshape(psi,length(FSTD.R),length(FSTD.H)+1);

FSTD.psi = .9*psi/sum(psi(:));


%% Initialize all variables, keeping the options we have initialized
Initialize_FD; 