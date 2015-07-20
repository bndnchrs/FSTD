% Get the advection in
% We want to get two things:
% ADVECT.conv_in - the total convergence of ice from outside the domain

if MECH.DO
    
    % Just take the convergence from outside the domain, iff it is zero
    ADVECT.conv_in = MECH.eps_I * (MECH.eps_I > 0);
       
else
    
    % must prescribe it elsewhere. Translate it from the ocean convergence
    ADVECT.conv_in = OCEAN.StrainInvar(1,FSTD.i) * ...
        ADVECT.ociccoeff * (FSTD.conc * ADVECT.H_0/MECH.Hmean) * ...
        ( 1 - exp(-(1-FSTD.conc)/ADVECT.ocicdelta));  
    
end

% ADVECT.fluxthrough - the total flux of ice through the domain

ADVECT.fluxtrough = OCEAN.fluxthrough(1,FSTD.i) * ...
        ADVECT.ociccoeff * (FSTD.conc * ADVECT.H_0/MECH.Hmean) * ...
        ( 1 - exp(-(1-FSTD.conc)/ADVECT.ocicdelta));  
    
    
