function [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT] = FD_Run(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT)
%% FD_Run
% This is the main driver of a single simulation: it uses
% previously initialized conditions and variables to simulate the floe
% distribution. Failing its external initialization, it contains a call
% initialize itself

% struct OPTS
% struct FSTD
% struct THERMO
% struct MECH
% struct SWELL
% struct OCEAN
% struct DIAG


if isfield(OPTS,'driven') && OPTS.driven == 0
    
    % There is a flag first_init in the initialization scheme which
    % computes all required fields if it is asked to.
        
    [FSTD,OPTS] = Initialize_FD(FSTD,OPTS);
    
    if OCEAN.DO
        
        [FSTD,OPTS,OCEAN] = Initialize_Ocean(FSTD,OPTS,OCEAN);
        
    end
    
end

DIAG.PLOT_TSTEP = 1;
DIAG.PLOT_FirstStep = 0;

%%

for i =  OPTS.start_it: OPTS.end_it
    
    FSTD.i = i;
       
    %%
    % Execute one timestep of the model
    
    if FSTD.DO
        
        
        [FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT] = FD_timestep(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT);
       
        
        % Print output and check for errors
        
    end
       
    %%
    if DIAG.DOPLOT
        
        FD_Plot;
        
    end
    
    
    
    drawnow
    
    if FSTD.eflag
        
        return
    
    end
        
    
end

end