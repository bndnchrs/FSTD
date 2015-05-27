%% function get_atten_dist.m
% This function calculates the wave attenuation distance W(\lambda) as well
% as the swell fracture timescales \tau(\lambda) using an approximation to
% the results obtained by Kohout and Meylan (2008).


% The expression is ln(alpha) = hbar - (1/6)sqrt(2 \pi \lambda/g) - 3 +
% ln(c/2 x r bar)


Lambda = Per.^(2)*g/(2*pi);

% This is the integral over N x R / integral over N, so the mean floe size
% by number
rbar = integrate_FD(numfloes,R',1);

% This is the integral over psi x H / integral over psi, so the mean ice
% thickness. This is also the same as the volume (psi x H) divided by the
% concentration (psi)
hbar = integrate_FD(psi,[H H_max],1);



% This will be called if we want to do full interpolation


load('Swell/int_interp_coeff')

%logalpha = interp2(interp_H,interp_P,atten,hbar,Per,'linear',-.5)';

if exist('polyfitter','var')
    
    if polyfitter == 1
        logalpha = polyval2(pv1,hbar,Per);
    else if polyfitter == 2
            logalpha = polyval2(pv2,hbar,Per);
        else if polyfitter == 3
                logalpha = polyval2(pv3,hbar,Per);
            else if polyfitter == 4
                    %% Exact Value from KM
                    logalpha = -2.38 + 0*polyval2(pv3,hbar,Per);
                end
            end
        end
    end
else
    logalpha = polyval2(pv2,hbar,Per);
end

% Linear fit to the KM08 output
% logalpha = log(10)*(hbar - .36*Per);

% Other linear fit, no positive alphas
% logalpha = .85*hbar - .75*Per + .74;
% logalpha(logalpha > -.5) = -.5;
% logalpha = logalpha';



alpha_notilde = exp(1).^(logalpha);


% The attenuation coefficient as a function of lambda.
alpha_atten = alpha_notilde * conc/(2*rbar);




% The attenuation distance
W_atten = 1./alpha_atten;

% The fraction of the domain occupied by waves of wavelength lambda
Atten_frac = min(W_atten / Domainwidth,1);

% The group velocity of waves with wavelength lambda
v_group = (1/2)*(g*Lambda/(2*pi)).^(1/2);

% the timescale for energy from waves of wavelength lambda to cross the domain
tau_swell = Domainwidth ./ v_group;



