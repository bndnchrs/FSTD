%% FD_initialize_swell
% This routine initializes the swell fracture code

%% Initialize Main Swell Variables

if ~exist('nP','var')
    nP = 500; % Number of Wave Period Bins
end

g = 9.81; 

if ~exist('Per','var')

    % Unless pre-defined, we choose the exact period bins so that each
    % wavelength will fracture into one and only one radius bin
    Per = (4*pi*R/g).^(1/2);
    
    
end

Lambda = Per.^(2)*g/(2*pi);

if ~exist('Domainwidth','var')

   % This is the width of the grid cell, for wave propagation
   Domainwidth = 1e1*1e3; % 1 kilometers

end

if exist('Do_interp_atten','var') && Do_interp_atten 
    
    load('Swell/interp_coeff')
    
end


% Vector of wave periods
% Per = linspace(minP,maxP,nP);

dP = [Per(1) diff(Per)];

% Calculate the outgoing
gamma_swell = calc_out_swell_FD(Per,R);

if ~exist('epscrit','var')
% The critical strain rate
epscrit = 3e-5;
end

if ~exist('tau_swell','var')
% Wave fracture timescale
tau_swell = 10;
end

%% Matrices for Handling In and Out
In_Swell = 0*psi;
Out_Swell = 0*psi;