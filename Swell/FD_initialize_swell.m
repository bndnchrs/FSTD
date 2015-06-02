%% FD_initialize_swell
% This routine initializes the swell fracture code

%% Initialize Main Swell Variables

if ~isfield(SWELL,'nP')
    SWELL.nP = 500; % Number of Wave Period Bins
end

g = 9.81; 

if ~isfield(SWELL,'Per')

    % Unless pre-defined, we choose the exact period bins so that each
    % wavelength will fracture into one and only one radius bin
    SWELL.Per = (4*pi*FSTD.R/g).^(1/2);
     
end

if ~isfield(SWELL,'prescribe_spec')
    % Whether the wave spectrum is imposed or not
    SWELL.prescribe_spec = 0; 
end

if ~isfield(SWELL,'H_s')
    SWELL.H_s = 2; % Significant Wave Height
end

if ~isfield(SWELL,'P_z')
    SWELL.P_z = 6; % Zero-crossing period
end

SWELL.Lambda = SWELL.Per.^(2)*g/(2*pi);

if ~isfield(OPTS,'Domainwidth')

   % This is the width of the grid cell, for wave propagation
   OPTS.Domainwidth = 1e1*1e3; % 1 kilometers

end

if isfield(SWELL,'Do_interp_atten') && SWELL.Do_interp_atten 
    
    load('Swell/interp_coeff')
    
end


% Vector of wave periods
% Per = linspace(minP,maxP,nP);

SWELL.dP = [SWELL.Per(1) diff(SWELL.Per)];

% Calculate the outgoing
SWELL.gamma_swell = calc_out_swell_FD(SWELL.Per,FSTD.R);

if ~isfield(SWELL,'epscrit')
% The critical strain rate
SWELL.epscrit = 3e-5;
end

if ~isfield(SWELL,'tau_swell')
% Wave fracture timescale
SWELL.tau_swell = 10;
end

%% Matrices for Handling In and Out
SWELL.In = 0*FSTD.psi;
SWELL.Out = 0*FSTD.psi;
