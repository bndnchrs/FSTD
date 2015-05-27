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

% There are several structures that need to be passed. 
% struct FSTD % FSTD op tions
% struct THERMO % Thermodynamics options
% struct MECH % Mechanics options
% struct SWELL % Swell fracture options
% struct OPTS % General options
% struct OCEAN % hehe . Contains information about the ocean model
% struct DIAG % Contains diagnostics
% struct EXFORC % Contains External Forcing

clear all

FSTD = struct(); 
OPTS = struct();
THERMO = struct(); 
MECH = struct(); 
SWELL = struct(); 
OCEAN = struct(); 
DIAG = struct(); 
EXFORC = struct(); 

[FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = Set_Run_Variables(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN) ;

%% Actually Run the Model
[FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = FD_Run(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN) ;

if FSTD.DO
    
    save(OPTS.NAMES{OPTS.run_number},'-v7.3')
    
end
