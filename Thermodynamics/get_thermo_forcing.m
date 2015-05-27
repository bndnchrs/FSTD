function get_thermo_forcing
%% get_solar_forcing
% This routine obtains the net energy flux to both the open water and
% ice-covered regions. It does not compute the outgoing long-wave over ice,
% however

global THERMO
global FSTD
global EXFORC
global OPTS
global OCEAN
% This 

OCEAN.LW = EXFORC.QLW(FSTD.i);
OCEAN.SW = EXFORC.QSW(FSTD.i); 
OCEAN.SH = -OPTS.SHLambda * (OCEAN.T + 273.14); 


% Heat flux above water 
if ~OCEAN.DO
EXFORC.Q_oc = OCEAN.LW + OCEAN.SW*(1-OPTS.alpha_oc) - OPTS.sigma * (THERMO.Toc + 273.14)^4 + OCEAN.SH; 
else
    EXFORC.Q_oc = OCEAN.LW + OCEAN.SW*(1-OPTS.alpha_oc) - OPTS.sigma * (OCEAN.T + 273.14)^4 + OCEAN.SH; 
end
% Heat flux above ice. This heat flux does not
% contain the outgoing long-wave, which is soved for in the thermodynamics.
EXFORC.Q_ic_noLW = OCEAN.LW + OCEAN.SW*(1- OPTS.alpha_ic);


end