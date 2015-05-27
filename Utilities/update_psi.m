%% update_psi
% This routing updates the floes distribution according to the maximal
% approved timestep dt_temp. It also updates the open water fraction and
% concentration, and removes a residual for floe sizes possessing less than
% a small percentage of the ice cover.

% new Floe Distribution
FSTD.psi = FSTD.psi + OPTS.dt_temp*FSTD.diff;

% new open water fraction
FSTD.openwater = 1 - sum(FSTD.psi(:)); 

FSTD.conc = sum(FSTD.psi(:));
FSTD.phi = 1 - FSTD.conc; 

%% Take away areas with very small concentrations

% In case we overshoot due to rounding errors, we adjust these
% (this will happen once in a while)

resid_adjust = FSTD.psi.*(abs(FSTD.psi) < eps);
FSTD.psi = FSTD.psi - resid_adjust;
FSTD.openwater = 1 - sum(FSTD.psi(:));
FSTD.conc = sum(FSTD.psi(:)); 
FSTD.NumberDist = FSTD.psi./(pi*FSTD.meshR.^2);
