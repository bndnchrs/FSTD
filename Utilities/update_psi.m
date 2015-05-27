%% update_psi
% This routing updates the floes distribution according to the maximal
% approved timestep dt_temp. It also updates the open water fraction and
% concentration, and removes a residual for floe sizes possessing less than
% a small percentage of the ice cover.

% new Floe Distribution
psi = psi + dt_temp*diff_FD;

% new open water fraction
openwater = 1 - sum(psi(:)); 

conc = sum(psi(:));

%% Take away areas with very small concentrations

% In case we overshoot due to rounding errors, we adjust these
% (this will happen once in a while)

resid_adjust = psi.*(abs(psi) < eps);
psi = psi - resid_adjust;
openwater = 1 - sum(psi(:));
conc = sum(psi(:)); 
numfloes = psi./(pi*meshR.^2);

clear resid_adjust 

