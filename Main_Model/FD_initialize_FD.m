function FD_initialize_FD
%% FD_initialize_FD
% This routine initializes the main floe distribution variables, including
% the floe distribution itself and many of the diagnostics

global OPTS %options files
global FSTD % FSTD files
%% Timestepping

% Times
OPTS.hour = 3600; 
OPTS.day = 24*OPTS.hour; 
OPTS.month = 30*OPTS.day; 
OPTS.year = 365*OPTS.day; 


if ~isfield(OPTS,'dt')
    % maximum time interval
    OPTS.dt = (1/8) * OPTS.day; % s
    
end

if ~isfield(OPTS,'nt')
    % number of timesteps
    OPTS.nt = round(15*OPTS.year / OPTS.dt);
    
end

if ~isfield(OPTS,'start_it')
    % Starting iteration
    OPTS.start_it = 1; 
end

if ~isfield(OPTS,'end_it')
    % Ending iteration
    OPTS.end_it = OPTS.nt; 
end

% Time Vector
FSTD.time = linspace(0,OPTS.nt*OPTS.dt,OPTS.nt); %s

% Time in years
FSTD.T = FSTD.time/OPTS.year; 

% Final Time
OPTS.tend = FSTD.time(end); %s

% Same
OPTS.timestepping = 0;

% iteration number
FSTD.i = 1;

% total number of iterations
OPTS.numsteps = 0;

% Total number of all iterations
OPTS.totnum = 0;




%% Floe Size Distribution

if ~isfield(OPTS,'nr')
    % Number of Size Classes
    OPTS.nr = 10;
end

if ~isfield(FSTD,'r_p')
    % Pancake Size
    OPTS.r_p = .5; % m
end

if ~isfield(OPTS,'dr')
    % Size Increment
    OPTS.dr = 10*OPTS.r_p; % m
end

if ~isfield(FSTD,'R')
% Vector of Sizes
FSTD.R = linspace(OPTS.r_p,OPTS.r_p + (OPTS.nr-1)*OPTS.dr,OPTS.nr);
end

%% Ice Thickness Distribution

if ~isfield(OPTS,'nh')
    % Number of Thickness Classes
    OPTS.nh = 10;
end

if ~isfield(OPTS,'h_p')
    % Pancake Thickness
    OPTS.h_p = .1; % m
end

if ~isfield(OPTS,'dh')
    % Thickness Increment
    OPTS.dh = 5*OPTS.h_p; % m
end

% Vector of Thickness
FSTD.H = linspace(OPTS.h_p,OPTS.h_p + (OPTS.nh-1)*OPTS.dh,OPTS.nh); % m

if ~isfield(FSTD,'H_max')
    % Maximum Thickness
    FSTD.H_max = max(FSTD.H) + OPTS.dh; %m
    
    if OPTS.nh == 0
        FSTD.H_max = OPTS.h_p; 
    end
end

% Initial Maximum Thickness
FSTD.H_max_i = FSTD.H_max;

% Area in Max Thickness
FSTD.A_max = 0;

FSTD.V_max_in = 0; 
FSTD.V_max_out = 0;
FSTD.V_max = 0; 

%% Dual Distribution

% 2-D matrix of size, thickness, and volume
[FSTD.meshR,FSTD.meshH] = meshgrid(FSTD.R,[FSTD.H FSTD.H_max]);
FSTD.meshR = FSTD.meshR';
FSTD.meshH = FSTD.meshH';
FSTD.meshV = pi*FSTD.meshR.^2 .* FSTD.meshH;

if ~isfield(FSTD,'psi')
    
    % Floe Distribution
    FSTD.psi = zeros(length(FSTD.R),length(FSTD.H)+1);
    
end

% Updating variables

FSTD.diff = 0*FSTD.psi;

FSTD.opening = 0;

FSTD.NumberDist = FSTD.psi./(pi*FSTD.meshR.^2);

% Open Water and Ice Concentration
FSTD.phi = 1 - sum(sum(FSTD.psi));
FSTD.conc = sum(sum(FSTD.psi));

if ~isfield(OPTS,'A_tot')
    % Domain Area and Radius
    OPTS.A_tot = 1e4*1e4;
    OPTS.r_tot = sqrt(OPTS.A_tot);
end

