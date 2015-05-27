%% Initialization

% Vector of sizes
H = .1; 
nr = 100;
r_p = .5;
h_p = .1;
dr = r_p;
R = linspace(r_p,100,nr); 

nt = 1000; % number of timesteps


minute = 60; 
hour = 3600; 
day = 86400; 
year = 365*86400; 

dt = day/24; % seconds
nt = round(15*year / dt);  

n = R.^(-2); 

% This part comes from Mechanics
n = n/sum(n);
numfloes = n./(pi*R.^2);

time = linspace(0,nt*dt,nt); % Time vector

% Do the execution
nsave = zeros(length(R),nt);
nsave(:,1) = n;

openwater = 1 - sum(n);
openwatertemp = openwater;
conc = sum(n);

% A_tot is the total area, r_tot is the total perimeter
A_tot = 1e4*1e4;
r_tot = sqrt(A_tot);

% Minimum value for which we will consider area to be in n
min_n = 1e-8;


