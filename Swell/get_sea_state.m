% get_sea_state

% This function retrieves the significant wave height and zero-crossing
% period at a given time


% Significant Wave Height
sigwaveheight = SWELL.H_s; % meters

% Zero-Crossing Period
zcperiod = SWELL.P_z; 

% Bretschneider Spectrum
SWELL.bret_spec = (1/(4*pi))*(sigwaveheight^2/zcperiod).*(SWELL.Per/zcperiod).^3 .* ... 
    exp((-1/pi) * (SWELL.Per/zcperiod).^4); 

% bret_spec = 0*bret_spec;
% bret_spec(44) = 1; 

% Amplitude, given the Bretschneider Spectrum
SWELL.bret_ampl = (SWELL.bret_spec.*[SWELL.Per(1) diff(SWELL.Per)]).^(1/2); 

% bret_ampl = 0*bret_ampl;
% bret_ampl(9) = 1; 

SWELL.bret_ampl = EXFORC.stormy(FSTD.i)*SWELL.bret_ampl; 

% Rayleigh Distribution of wave amplitudes
Hsqbar = sigwaveheight^2 / 2; 

SWELL.rayleigh = (2*SWELL.bret_ampl/Hsqbar) .* exp(1).^(-(SWELL.bret_ampl.^2)/Hsqbar); 
SWELL.rayleigh = repmat(SWELL.rayleigh',[1 length(FSTD.R) length(FSTD.H)+1]);  

% Probability of Fracture, Given by external program
SWELL.Prob_swellfrac = get_prob_frac_FD(SWELL.bret_ampl,SWELL.rayleigh,FSTD.R,[FSTD.H FSTD.H_max],SWELL.epscrit,SWELL.Per);


