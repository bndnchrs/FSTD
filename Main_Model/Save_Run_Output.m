function Save_Run_Output(FSTD,OPTS,THERMO,MECH,SWELL,DIAG,EXFORC,OCEAN,ADVECT)
% Save_Run_Output
% This is a file that saves each run as its own file. It is called in this
% way to allow it to be nested inside a parfor loop

% Save the files
save(['../FSTD-OUTPUT/' OPTS.NAME],'FSTD','OPTS','THERMO','MECH','SWELL','OCEAN','DIAG','EXFORC','ADVECT','-v7.3')

end