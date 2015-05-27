% get_sea_state

% This function retrieves the significant wave height and zero-crossing
% period at a given time


% Significant Wave Height
sigwaveheight = 2; % meters

% Zero-Crossing Period
zcperiod = 6; 

% Bretschneider Spectrum
bret_spec = (1/(4*pi))*(sigwaveheight^2/zcperiod).*(Per/zcperiod).^3 .* ... 
    exp((-1/pi) * (Per/zcperiod).^4); 

% bret_spec = 0*bret_spec;
% bret_spec(44) = 1; 

% Amplitude, given the Bretschneider Spectrum
bret_ampl = (bret_spec.*[Per(1) diff(Per)]).^(1/2); 

% bret_ampl = 0*bret_ampl;
% bret_ampl(9) = 1; 

bret_ampl = stormy(III,i)*bret_ampl; 

% Rayleigh Distribution of wave amplitudes
Hsqbar = sigwaveheight^2 / 2; 

rayleigh = (2*bret_ampl/Hsqbar) .* exp(1).^(-(bret_ampl.^2)/Hsqbar); 
rayleigh = repmat(rayleigh',[1 length(R) length(H)+1]);  

% Probability of Fracture, Given by external program
Prob_swellfrac = get_prob_frac_FD(bret_ampl,rayleigh,R,[H H_max],epscrit,Per);


