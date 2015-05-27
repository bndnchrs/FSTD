work2div = 0*(1:nt);
ridgework = 0*(1:nt);
raftwork = 0*(1:nt);
magsave = 0*(1:nt);
openersave = 0*(1:nt);
divsave = 0*(1:nt);
eps2save = 0*(1:nt);
PSAVE = 0*(1:nt);
Press = 0; 
VSAVE =0*(1:nt);
HSAVE = 0*(1:nt);
OWSAVE = 0*(1:nt);
THETASAVE = 0*(1:nt);
concsave = 0*(1:nt);
diffsave = zeros(length(R),nt);
MFS = 0*(1:nt);
opensave = 0*(1:nt);
open0save = 0*(1:nt);
Rmeanarea = 0*(1:nt);
Rmeannum = 0*(1:nt);
smallfloes = 0*(1:nt);
smallmfs = 0*(1:nt);
bigmfs = 0*(1:nt);
bigfloes = 0*(1:nt);
gamsave = 0*(1:nt);
r_raft = 0; 
r_ridge = 0; 
k_ridge = 0; 
SR = 0*zeros(2,2); 
S_Out_raft = zeros(length(R),length(R)); 

Kfac_raft = S_Out_raft; 


if doMech == 1


% Size of a rafting floe
r_raft = 10;
r_ridge = 5;

% Thickness Increase Multiple
k_ridge = 5;

% Initial Thickness 

% Randomized Strain Rate
SR = 0*(rand(2,2,1)-.5)*1e-6;
% SR = repmat(SR,[1 1 nt]);
% SR(1,2,:) = SR(2,1,:);

%n = 0*R; % Floe Size Distribution
% n = gaussmf(R,[r_p R(20)]);% + gaussmf(R,[r_p R(100)]) ;
%n = R.^(-2);
%n(length(n)/2) = .5;
%n = n+1;
%n(n < 1e-2) = 0;
%n(20:end) = 0;
% n(1) = 1;


% S_out is a delta function giving the combined floe sizes
% Kstar is the 1 - fractional area lost in combination
% Prob_Interact is the probability two floe sizes interact

disp('Calculating Interaction Matrices for Rafting ...')

[S_Out_raft,Kfac_raft,Prob_Interact_raft,Kstar_raft] = calc_sizes_raft(R,r_raft,A_tot);

disp('Calculating Interaction Matrices for Ridging ...')

[S_Out_ridge,Kfac_ridge,Prob_Interact_ridge,Kstar_ridge] = calc_sizes_ridge(R,r_ridge,A_tot,k_ridge);

%%
sumprob = sum(Prob_Interact_raft(:) + Prob_Interact_ridge(:));
Prob_Interact_raft = Prob_Interact_raft / sumprob;
Prob_Interact_ridge = Prob_Interact_ridge / sumprob;


H_raft = .3;

gamma_ridge = calc_gamma_ridge(H,H_raft);


In = zeros(1,length(R));
In_raft = In;
In_ridge = In;
Out = In;
Out_raft = In;
Out_ridge = In;



disp('Iterating');

%STRR= load('SR_RP');
%divsave = STRR.divsave;
%eps2save = STRR.eps2save;

SR = zeros(2,2); 


P_0 = H*exp(-20*openwater); 

end

