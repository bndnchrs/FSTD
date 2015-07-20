%% Initializing the advection scheme, used to transport ice in from other locations

%
if FSTD.DO
    
    if ~isfield('ADVECT.in_ice','var')
        % Do we advect stuff in
        ADVECT.in_ice = 1; 
    end
    
    if ~isfield('ADVECT.out_ice','var')
        
        % Do we advect stuff out
        % If no, things only removed from domain when concentration is over
        % 1 (i.e. convergence isn't enough to compensate the flow in)
        ADVECT.out_ice = 1; 
        
    end
    
    
    if ~isfield('ADVECT.FSD_in','var')
        % If no specified field, make it uniform
        ADVECT.FSTD_in = 0 * FSTD.meshR + 1/prod(size(FSTD.meshR));
    end
    
    
end