%% Initialize_Run_Wrapper

FSTD = struct(); 
OPTS = struct(); 
THERMO = struct(); 
MECH = struct(); 
SWELL = struct(); 
OCEAN = struct(); 
DIAG = struct(); 
EXFORC = struct(); 


OPTS.numruns = 1; 
OPTS.NAMES = {'SavedOutput/Storms_Tmelt_1thick1m_noadv_dummy',...
    'SavedOutput/NoStorms_Tmelt_1thick1m_noadv'};
