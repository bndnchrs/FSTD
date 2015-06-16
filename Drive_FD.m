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

%% Actually Run the Model

clear

% This is where the input files will be located. Add them into the PATH. 
location_of_files = 'Runs/Vary_Strain_Rate_Merge';
addpath(location_of_files)

% Initialize the basic run variables (save locations, etc)
Initialize_Run_Wrapper;

parfor runnum = 1:numruns
    
    % This creates the structures and sets the general variables
    [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = Set_General_Run_Variables(runnum,NAMES);
    
    % This sets the run-specific variables
    [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = Set_Specific_Run_Variables(runnum,FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN);
    
    % This actually runs the damn thing
    [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN] = FD_Run(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN) ;
    
    % This saves it. Sent as a function to be compatible with parfor
    Save_Run_Output(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN);
    %  save(['../FSTD-OUTPUT/' OPTS.NAMES{OPTS.run_number}],'-v7.3')
    
end

