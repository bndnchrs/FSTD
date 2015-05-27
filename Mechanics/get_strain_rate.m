function get_strain_rate

global MECH
global FSTD
global EXFORC

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
MECH.eps_I = EXFORC.nu(FSTD.i,1); 
MECH.eps_II = EXFORC.nu(FSTD.i,2); 

% Example forced strain rate tensor
MECH.Hmean = integrate_FD(FSTD.psi,[FSTD.H FSTD.H_max],1);

if MECH.Hmean == 0
    MECH.Hmean = MECH.h_p;
end

if ~isfield(MECH,'dont_rescale_eps') || MECH.dont_rescale_eps == 0
    
    MECH.eps_I = MECH.eps_I*(FSTD.conc)*(MECH.H_0/MECH.Hmean);
    MECH.eps_II = MECH.eps_II*(FSTD.conc)*(MECH.H_0/MECH.Hmean);
    
end

%% This is for cases in which we want to turn off and on mech
MECH.eps_I = MECH.eps_I * EXFORC.compressing(FSTD.i); 
MECH.eps_II = MECH.eps_II * EXFORC.compressing(FSTD.i); 

%%
% Magnitude of Strain Rate Tensor
MECH.mag = sqrt(MECH.eps_I^2 + MECH.eps_II^2);
% Ratio of Divergence to Strain
costheta = MECH.eps_I/MECH.mag;

% Opening and closing coefficients
MECH.alpha_0 = .5*(1 + costheta);
MECH.alpha_c = .5*(1 - costheta);

%%

end
