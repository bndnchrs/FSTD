% get_atten_dist
% This function calculates the wave attenuation distance W(\lambda) as well
% as the swell fracture timescales \tau(\lambda) using an approximation to
% the results obtained by Kohout and Meylan (2008).


% The expression is ln(alpha) = hbar - (1/6)sqrt(2 \pi \lambda/g) - 3 +
% ln(c/2 x r bar)
g = 9.81;

SWELL.Lambda = SWELL.Per.^(2)*g/(2*pi);

% This is the integral over N x R / integral over N, so the mean floe size
% by number
rbar = integrate_FD(FSTD.NumberDist,FSTD.R',1);

% This is the integral over psi x H / integral over psi, so the mean ice
% thickness. This is also the same as the volume (psi x H) divided by the
% concentration (psi)
hbar = integrate_FD(FSTD.psi,[FSTD.H FSTD.H_max],1);



% This will be called if we want to do full interpolation
load('Swell/int_interp_coeff')

%logalpha = interp2(interp_H,interp_P,atten,hbar,Per,'linear',-.5)';

if isfield(SWELL,'polyfitter')
    
    if SWELL.polyfitter == 1
        SWELL.logalpha = polyval2(pv1,hbar,SWELL.Per);
    else if SWELL.polyfitter == 2
            SWELL.logalpha = polyval2(pv2,hbar,SWELL.Per);
        else if SWELL.polyfitter == 3
                SWELL.logalpha = polyval2(pv3,hbar,SWELL.Per);
            else if SWELL.polyfitter == 4
                    %% Exact Value from KM
                    SWELL.logalpha = -2.38 + 0*polyval2(pv3,hbar,SWELL.Per);
                end
            end
        end
    end
else
    SWELL.logalpha = polyval2(pv2,hbar,SWELL.Per);
end

% Linear fit to the KM08 output
% logalpha = log(10)*(hbar - .36*Per);

% Other linear fit, no positive alphas
% logalpha = .85*hbar - .75*Per + .74;
% logalpha(logalpha > -.5) = -.5;
% logalpha = logalpha';



alpha_notilde = exp(1).^(SWELL.logalpha);


% The attenuation coefficient as a function of lambda.
SWELL.alpha_atten = alpha_notilde * FSTD.conc/(2*rbar);




% The attenuation distance
SWELL.W_atten = 1./SWELL.alpha_atten;

% The fraction of the domain occupied by waves of wavelength lambda
SWELL.Atten_frac = min(SWELL.W_atten / OPTS.Domainwidth,1);

% The group velocity of waves with wavelength lambda
v_group = (1/2)*(g*SWELL.Lambda/(2*pi)).^(1/2);

% the timescale for energy from waves of wavelength lambda to cross the domain
SWELL.tau_swell = OPTS.Domainwidth ./ v_group;
