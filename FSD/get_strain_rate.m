%% Strain Rate Stuff, Constant at each timstep


fixedSR = 1; 

% eps_I = 0; 
% eps_II = 3.1710e-08; 

if fixedSR == 0
    
SR = SR + (rand(2,2,1)-.5)*1e-8;
SR(1,2) = SR(2,1);
strain_tensor = SR;
eps_I = trace(strain_tensor);
% eps_I = divsave(i);
eps_I = -1e-8;
dev = strain_tensor - diag([eps_I;eps_I])/2;
dev =det(dev);
if abs(dev) <  eps
    dev = 0;
end

eps_II = sqrt(-2*dev)+eps;
% eps_II = eps2save(i);
eps_II = 0;

end


% Magnitude of Strain Rate Tensor
mag = sqrt(eps_I^2 + eps_II^2);
% Ratio of Divergence to Strain
theta = atan(eps_II/eps_I);
costheta = eps_I/mag;
%   costheta = -1;

alpha_0 = .5*(1 + costheta);
alpha_c = .5*(1 - costheta);