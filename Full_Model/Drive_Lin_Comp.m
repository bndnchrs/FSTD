%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

%% Initialization
clearvars

%% First initialize the main variables and overwrite main variables
first_init = 1;

nt = 365;
dt = 86400;
nr = 50;
dr = 3;
nh = 50;
dh = .05;


Initialize_FD;

%% Overwrite Those Variables we want changed from modules

var = [3^2 .125^2];

ps1 = mvnpdf([meshR(:) meshH(:)],[6.5 1.5],var);
ps2 = mvnpdf([meshR(:) meshH(:)],[87.5 .3],var);

psi = ps1/sum(ps1(:))+ ps2/sum(ps1(:));


psi = reshape(psi,length(R),length(H)+1);


%%
psi = .1*psi/sum(psi(:));


tau_swell = 100*day;
epscrit = .01;

eps_I = -.5e-8;
eps_II = 0;

Q_surf = -100*ones(1,nt);

%% Now initialize modules

first_init = 0;

do_FD = 1;
do_Mech = 1;
do_Thermo = 1;
do_Swell = 1;

do_Plot = 1;
do_Diagnostics = 1;

Initialize_FD;

do_Mech = 0; 
do_Thermo = 0; 
do_Swell = 0; 

%% Actually Run the Model

driven = 1;


FD_Run_NonLin;


FD_Plot;


save(Outname)

