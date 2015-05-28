function [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN]  = Set_General_Run_Variables(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN) 
% Generic script to set general options common to all runs

%% Set basic parameters having to do with options
% Discretization and so on

OPTS.nt = 24*7*16*5; % Number of timesteps
OPTS.dt = 3600; % Timestep duration
OPTS.dr = 2; % Size increment
OPTS.nh = 13; % No. thickness categories
OPTS.dh = .2; % Thickness increment

OPTS.time = linspace(OPTS.dt,OPTS.nt*OPTS.dt,OPTS.nt); 

R(1) = .5;
for i = 2:64
    R(i) = sqrt(2*R(i-1)^2 - (4/5) * R(i-1)^2);
end
OPTS.nr = length(R); % Number of size categories
FSTD.R = R;
OPTS.r_p = .5; % Minimum floe size category
OPTS.h_p = .1; % Minimum thickness category
clear R
FSTD.H = .1:OPTS.dh:2.5;

%% Just get the basic fields we need
OPTS.first_init = 1;

addpath('Main_Model')

[FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = Initialize_FD(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN); 

%% Set Thermodynamic Options

THERMO.allow_adv_loss_H = 0; % Allow for loss of ice through decreasing thickness
THERMO.allow_adv_loss_R = 0;
OPTS.SHLambda = 1/100; 


%% Set Swell Fracture Options
OPTS.Domainwidth = 5e4;
SWELL.epscrit = .01;

%% Set Ocean Options
OCEAN.taui = 86400; 
OCEAN.no_oi_hf = 0; 
OCEAN.H = 50; 