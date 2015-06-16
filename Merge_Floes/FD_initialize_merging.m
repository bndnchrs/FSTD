if FSTD.DO
    
    if ~isfield(THERMO,'deltamerge')
        % The multiple of size over which floes will merge together
        THERMO.deltamerge = 5; 
    end
    
    
    
end