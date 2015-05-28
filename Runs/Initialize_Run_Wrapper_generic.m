% Generic Wrapper Script

% Initialize all the structures
FSTD = struct(); 
OPTS = struct(); 
THERMO = struct(); 
MECH = struct(); 
SWELL = struct(); 
OCEAN = struct(); 
DIAG = struct(); 
EXFORC = struct(); 

% Basic variables: number of runs and the location their output will be
% saved
OPTS.numruns = 2; 
OPTS.NAMES = {'Dummy',...
    'Dummy'};
