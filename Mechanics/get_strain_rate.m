%% get_strain_rate
% This routine pulls or creates the strain rate state at each large-scale
% timestep, and assorted necessasry quantities.

% If we are going to simulate out own, use this

% strain_tensor = strain_tensor + (rand(2,2,1)-.5)*1e-8;
% strain_tensor(1,2) = strain_tensor(2,1);

% If undriven we can use our own strain rate stuff
%  if ~exist('undriven','var') || (exist('undriven','var') && undriven == 1)
%      eps_I = -1e-7;
%      eps_II = 0;
%  end

% dev = strain_tensor - diag([eps_I;eps_I])/2;
% dev = det(dev);

% if abs(dev) <  eps
%     dev = 0;
% end

% Using Random-Walk timeseries
eps_I = nu(i,1); 
eps_II = nu(i,2); 

% Example forced strain rate tensor
Hmean = integrate_FD(psi,[H H_max],1);

if Hmean == 0
    Hmean = h_p;
end

if ~exist('dont_rescale_eps','var')
    
    eps_I = eps_I*(conc)*(H_0/Hmean);
    eps_II = eps_II*(conc)*(H_0/Hmean);
    
end

%% This is for cases in which we want to turn off and on mech
eps_I = eps_I * compressing(III,i); 
eps_II = eps_II * compressing(III,i); 

%%
% Magnitude of Strain Rate Tensor
mag = sqrt(eps_I^2 + eps_II^2);
% Ratio of Divergence to Strain
theta = atan(eps_II/eps_I);
costheta = eps_I/mag;

% Opening and closing coefficients
alpha_0 = .5*(1 + costheta);
alpha_c = .5*(1 - costheta);

%%
clear theta costheta 
