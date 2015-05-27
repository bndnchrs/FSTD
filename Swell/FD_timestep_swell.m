%% This code executes one timestep of the swell fracture code

In_Swell = 0*psi; 
Out_Swell = 0*psi; 

for P1 = 1:length(Per)
    % Integrate over periods
    for r1 = 1:length(R)
        % Integrate over floe sizes
        for h1 = 1:length(H)+1
            % Integrate over floe thickness
            inloc = gamma_swell(P1);
            outloc = r1;
            
            % Just transfer area between the two
            In_Swell(inloc,h1) = In_Swell(inloc,h1) + (1/tau_swell(P1))*Atten_frac(P1)*Prob_swellfrac(P1,outloc,h1)*psi(outloc,h1);
            Out_Swell(outloc,h1) = Out_Swell(outloc,h1) + (1/tau_swell(P1))*Atten_frac(P1)*Prob_swellfrac(P1,outloc,h1)*psi(outloc,h1);
            
        end
    end
end

% tscale = tau_swell; 
% 
% 
% In_Swell = In_Swell / tscale; 
% Out_Swell = Out_Swell / tscale; 
diff_swell = In_Swell - Out_Swell; 


% Keeping track of the volume in the largest floe thickness
V_max_in_swell = H_max*sum(In_Swell(:,end)); 
V_max_out_swell = H_max*sum(Out_Swell(:,end)); 
