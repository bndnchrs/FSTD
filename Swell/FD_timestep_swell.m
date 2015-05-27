function FD_timestep_swell

global FSTD
global SWELL

%% This code executes one timestep of the swell fracture code


SWELL.In = 0*FSTD.psi; 
SWELL.Out = 0*FSTD.psi; 

for P1 = 1:length(SWELL.Per)
    % Integrate over periods
    for r1 = 1:length(FSTD.R)
        % Integrate over floe sizes
        for h1 = 1:length(FSTD.H)+1
            % Integrate over floe thickness
            inloc = SWELL.gamma_swell(P1);
            outloc = r1;
            
            % Just transfer area between the two
            SWELL.In(inloc,h1) = SWELL.In(inloc,h1) + (1/SWELL.tau_swell(P1))*SWELL.Atten_frac(P1)*SWELL.Prob_swellfrac(P1,outloc,h1)*FSTD.psi(outloc,h1);
            SWELL.Out(outloc,h1) = SWELL.Out(outloc,h1) + (1/SWELL.tau_swell(P1))*SWELL.Atten_frac(P1)*SWELL.Prob_swellfrac(P1,outloc,h1)*FSTD.psi(outloc,h1);
            
        end
    end
end

% tscale = tau_swell; 
% 
% 
% In_Swell = In_Swell / tscale; 
% Out_Swell = Out_Swell / tscale; 
SWELL.diff = SWELL.In - SWELL.Out; 


% Keeping track of the volume in the largest floe thickness
SWELL.V_max_in = FSTD.H_max*sum(SWELL.In(:,end)); 
SWELL.V_max_out = FSTD.H_max*sum(SWELL.Out(:,end)); 

end