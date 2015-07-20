function [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT]  = Set_General_Run_Variables(runnum,NAMES)
% Create the structures
FSTD = struct(); 
OPTS = struct(); 
THERMO = struct(); 
MECH = struct(); 
SWELL = struct(); 
OCEAN = struct(); 
DIAG = struct(); 
EXFORC = struct(); 
ADVECT = struct();


%% Set General options
OPTS.NAME = NAMES{runnum};
OPTS.run_number = runnum;


OPTS.nt = 24*30; % Number of timesteps
OPTS.dt = 3600; % Timestep duration
OPTS.dr = 2; % Size increment
OPTS.nh = 13; % No. thickness categories
OPTS.dh = .2; % Thickness increment


OPTS.time = linspace(OPTS.dt,OPTS.nt*OPTS.dt,OPTS.nt); 

% Initial discretization
RR(1) = .5;
for i = 2:70
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

addpath('Main_Model')

[FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT] = Initialize_FD(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT); 

%% Set Thermodynamic Options

OPTS.SHLambda = 0*1/100; 


%% Set Swell Fracture Options
OPTS.Domainwidth = 5e4;
SWELL.epscrit = .01;

%% Set Ocean Options
OCEAN.no_oi_hf = 0; 
OCEAN.H = 50; 

%% Set Advection Options
ADVECT.in_ice = 1;
ADVECT.out_ice = 1; 

