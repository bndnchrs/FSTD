%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

% It is written in general format for future runs

% There are five major structure files which govern the development of the
% FSTD. They are

% FSTD: which contains PSI as well as other related variables
% THERMO: containing the thermodynamic options
% MECH: similar, for mechanics
% SWELL: similar, for swell fracture
% OPTS: containing global options

clearvars -global

global FSTD % FSTD op tions
global THERMO % Thermodynamics options
global MECH % Mechanics options
global SWELL % Swell fracture options
global OPTS % General options
global OCEAN % hehe . Contains information about the ocean model
global DIAG % Contains diagnostics
global EXFORC % Contains External Forcing



Set_Run_Variables;

%% Actually Run the Model
FD_Run;

if FSTD.DO
    
    save(OPTS.NAMES{OPTS.run_number},'-v7.3')
    
end
