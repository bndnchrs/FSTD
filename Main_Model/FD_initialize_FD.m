%% FD_initialize_FD
% This routine initializes the main floe distribution variables, including
% the floe distribution itself and many of the diagnostics

%% Timestepping

% Times
hour = 3600; 
day = 24*hour; 
month = 30*day; 
year = 365*day; 


if ~exist('dt','var')
    % maximum time interval
    dt = (1/8) * day; % s
    
end

if ~exist('nt','var')
    % number of timesteps
    nt = round(15*year / dt);
    
end

if ~exist('start_it','var')
    % Starting iteration
    start_it = 1; 
end

if ~exist('end_it','var')
    % Ending iteration
    end_it = nt; 
end

% Time Vector
time = linspace(0,nt*dt,nt); %s

% Time in years
T = time/year; 

% Final Time
tend = time(end); %s

% Same
timestepping = 0;

% iteration number
i = 1;

% total number of iterations
numsteps = 0;

% Total number of all iterations
totnum = 0;




%% Floe Size Distribution

if ~exist('nr','var')
    % Number of Size Classes
    nr = 10;
end

if ~exist('r_p','var')
    % Pancake Size
    r_p = .5; % m
end

if ~exist('dr','var')
    % Size Increment
    dr = 10*r_p; % m
end

if ~exist('R','var')
% Vector of Sizes
R = linspace(r_p,r_p + (nr-1)*dr,nr);
end

%% Ice Thickness Distribution

if ~exist('nh','var')
    % Number of Thickness Classes
    nh = 10;
end

if ~exist('h_p','var')
    % Pancake Thickness
    h_p = .1; % m
end

if ~exist('dh','var')
    % Thickness Increment
    dh = 5*h_p; % m
end

% Vector of Thickness
H = linspace(h_p,h_p + (nh-1)*dh,nh); % m

if ~exist('H_max','var')
    % Maximum Thickness
    H_max = max(H) + dh; %m
    
    if nh == 0
        H_max = h_p; 
    end
end

% Initial Maximum Thickness
H_max_i = H_max;

% Area in Max Thickness
A_max = 0;

V_max_in = 0; 
V_max_out = 0; 

%% Dual Distribution

% 2-D matrix of size, thickness, and volume
[meshR,meshH] = meshgrid(R,[H H_max]);
meshR = meshR';
meshH = meshH';
meshV = pi*meshR.^2 .* meshH;

if ~exist('psi','var')
    
    % Floe Distribution
    psi = zeros(length(R),length(H)+1);
    
end

% Updating variables

diff_FD = 0*psi;

opening = 0;

numfloes = psi./(pi*meshR.^2);

% Largest Thickness Category
FSD_thick = zeros(nr,1);

% Initial marginal distributions
ITD = sum(psi,1);
FSD = sum(psi,2);

% Open Water and Ice Concentration
openwater = 1 - sum(sum(psi));
conc = sum(sum(psi));

if ~exist('A_tot','var')
    % Domain Area and Radius
    A_tot = 1e4*1e4;
    r_tot = sqrt(A_tot);
end

%

