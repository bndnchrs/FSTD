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

if isfield(MECH,'prescribenu')
    
    % Using Random-Walk timeseries
    MECH.eps_I = EXFORC.nu(FSTD.i,1);
    MECH.eps_II = EXFORC.nu(FSTD.i,2);
    
end

MECH.Hmean = integrate_FD(FSTD.psi,[FSTD.H FSTD.H_max],1);

if MECH.Hmean == 0
    MECH.Hmean = MECH.h_p;
end


if isfield(MECH,'simple_oc_sr') && MECH.simple_oc_sr
    % Strain rate is inferred from the ocean strain rate tensor
    MECH.oc_to_ic = MECH.ociccoeff * (FSTD.conc * OPTS.H_0/MECH.Hmean) * ( 1 - exp(-(1-FSTD.conc)/MECH.ocicdelta));  
    
    % Convert the ocean strain rate tensor by the above factor
    MECH.eps_I = OCEAN.StrainInvar(1,FSTD.i) * MECH.oc_to_ic; 
    MECH.eps_II = OCEAN.StrainInvar(2,FSTD.i) * MECH.oc_to_ic; 
    
end
   
  
if isfield(MECH,'rescale_eps') && MECH.rescale_eps
    % A seperate rescaling in the ice thickness and concentration
    
    MECH.eps_I = MECH.eps_I*(FSTD.conc)*(OPTS.H_0/MECH.Hmean);
    MECH.eps_II = MECH.eps_II*(FSTD.conc)*(OPTS.H_0/MECH.Hmean);
    
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
