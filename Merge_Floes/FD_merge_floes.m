% function FD_merge_floes.m
% This script is performed in the case of thermodynamic freezing
% When this is occuring, we merge floes together
% This is done at a rate approximately equal to dot(r)/(1-c)^2       
if THERMO.DO
   %%
    if THERMO.mergefloes && THERMO.drdt > 0 && FSTD.conc < 1
     %%
       % This is a flag, and we must be freezing in order to merge floes.
       % If the concentration is equal to 1, we must also quit
       
       % get the mean reciprocal size (int r f(r) dr)
       Mn1 = integrate_FD(FSTD.psi,1./FSTD.meshR,0); 
      

       % This is the total consolidated area, divided by the ice
       % concentration
       THERMO.alphamerge = 2 * THERMO.drdt * Mn1 / (1 - FSTD.conc)^2;
        
       THERMO.loss_merge = THERMO.alphamerge * FSTD.psi;
       THERMO.gain_merge = 0*THERMO.loss_merge; 
       
       for i = 1:length(FSTD.R)-1
           % Largest floe size does not experience merging
           % For each floe size
           
           % This gets the largest multiple (a factor of deltamerge)
           maxR = FSTD.R(i) * THERMO.deltamerge; 
           
           isbigg = sum((maxR - FSTD.R(i+1:end) > 0));
           
           THERMO.gain_merge(i+1:i+isbigg,:) = ...
               bsxfun(@plus,THERMO.gain_merge(i+1:i+isbigg,:),1/isbigg * THERMO.loss_merge(i,:)); 
           
       end
       
       THERMO.gain_merge(end,:) = THERMO.gain_merge(end,:) + THERMO.loss_merge(end,:); 
           
       THERMO.diff_merge = THERMO.gain_merge - THERMO.loss_merge; 
                            
       
    end
    
    % This is the volume flux to the largest thickness class
    THERMO.V_max_in_merge = sum(THERMO.diff_merge(:,end)*FSTD.H_max); 
    
    
else
    
    error('Thermodynamics is not on, cannot merge floes')
    
end