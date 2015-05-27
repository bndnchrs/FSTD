%% Thorndike_timestep
% This code simulates one timestep of the Thorndike model for the ice
% thickness distribution. We use the stock model from Thorndike '75, which
% has thermodynamics and mechanics. The growth rate of ice (Thorndike's
% f(h) is calculated as in the FSD-ITD model. Interactions are handled
% using Thorndike's same a(h) and n(h) presupposing a 5-fold increase in
% ice thickness in collision. 

% In this way, the thermodynamics component is left unaltered. The
% mechanics is altered to be dependent on floe thicknesses, not floe sizes,
% and to be a statistical model and not one which depends on collisions
% between floes. 

% Note that this model only applies in the case that there is one floe
% size. Interaction probabilities are completely governed by this fact. 


%Thorndikes model has a ridging mode w_r which is the sum of two
%distributions: a(h) which is the "loss" term and n(h) which is the "gain"
%term. a(h) = b(h)G(h) 


% The mechanics of the model are more or less the same as in the FSD-ITD
% mechanics but the kernel is adjusted.

CUM_ITD = cumsum(ITD); 


In = 0*CUM_ITD; 
Out = 0*CUM_ITD; 

% Above this cumulative fraction, ridging will not occur. 
Gstar = .15;

Thorndike_b = (2/Gstar)*(1 - CUM_ITD/Gstar);  
Thorndike_b(CUM_ITD > Gstar) = 0; 

if min(CUM_ITD) > Gstar
    Thorndike_b(min(find(psi))) = 1;
end

% The integral of bdG should be equal to one, per Thorndike '79
Thorndike_b = Thorndike_b * (1 / sum(Thorndike_b .* CUM_ITD)); 


% This is the "outgoing mode"
Thorndike_a = Thorndike_b .* ITD; 

% H values less than k. 
Hdivk = [H H_max]/k_ridge; 
% We will interpolate a to these values in order to get the function
% n(h/k). 

adivk = interp1([H H_max],Thorndike_a,Hdivk,'linear','extrap'); 

% The interpolation is not exact so we fudge a bit and get the numbers
% right
Thorndike_n = (1/k_ridge^2)*adivk; 
Thorndike_n = Thorndike_n.*(psi ~= 0);
Thorndike_n = Thorndike_n * sum(Thorndike_a .* [H H_max])/sum(Thorndike_n .* [H H_max]);

if sum(Thorndike_a) == 0
    Thorndike_n = Thorndike_a; 
end
%
Out = -Thorndike_a; 
In = Thorndike_n; 

diff_mech = In + Out; 

% We can use a more complicated "in-out" framework to do this but 
% interpolation suits us just fine for now. 
% 
% 
% % Now we pick out where the ice goes, and how much area we need to put into
% % the new floe class in order to conserve volume. 
% [Thorndike_S_H,Thorndike_Kfac] = calc_sizes_Thorndike([H H_max],k_ridge);
% 
% for hi = 1:length(H)+1
%     
%     toend = min(length(H)+1,Thorndike_S_H(hi)+2);
%     toend = max(toend,hi); 
%     tobeg = max(1,Thorndike_S_H(hi)-2); 
%     tobeg = max(tobeg,hi); 
%     
% %    tobeg= Thorndike_S_H(hi); 
% %    toend = tobeg;
%     
%     Thorndike_smooth = toend - tobeg + 1;
%     
%     
%   %  In(tobeg:toend) = In(tobeg:toend) + (1/Thorndike_smooth)*Thorndike_a(hi); 
%     LongH = [H H_max]; 
%     ComingIn = LongH(hi)*Thorndike_a(hi); 
%     
%     
%     
%     for Inind = tobeg:toend
%         In(Inind) = In(Inind) + (1/Thorndike_smooth)*ComingIn*(1/LongH(Inind)); 
%     end
%         
%             
% end


%% Now we have to deal with thornier issues for the model

diffeps =0; 
if sum(sum(abs(diff_mech))) == 0
    diffeps = eps;
end

% diff is the ridging mode, must be normalized to -1
normalizer = sum(sum(diff_mech)) + diffeps;

diff_mech = - diff_mech / normalizer;

In = - mag*alpha_c*In / normalizer;
Out = - mag*alpha_c*Out / normalizer;

% Here is the "convergent mode" part of the total change in ice
% partial concentrations, which tells how much redistribution is
% done in a "volume conserving" way.

diff_mech = mag*alpha_c*diff_mech;

% This is the divergent mode, the total amount of water opened by
% divergence of water, which replaces ice with open water and drops
% the volume
divopening = mag*alpha_0;

% At the moment, volume is not conserved: this is because some
% volume has left the "regular" floe sizes to reach the largest
% thickness category, and some of the area has left the largest
% thickness category, as well. We must update the ice thickness in
% this category to reflect these changes
% On the other hand, area has been correctly reported to all floe
% sizes.
V_max_in_mech = -integrate_FD(diff_mech(:,1:end-1),H,0);

% Open water is that from divergence + that freed up by convergence
opening_mech = divopening - sum(diff_mech(:));


if sum(psi(:)) <= 1e-8
    diff_mech = 0*psi;
    opening_mech = 0;
    diffeps = eps;
    psi = 0*psi;
    openwater = 1;
end


%% Loss due to divergence of ice
diffadv = (psi/(sum(sum(psi))+diffeps))*divopening;

% Here is the amount of ice volume which is lost from the largest
% thickness category due to divergenceH
V_max_out_mech = H_max*sum(diffadv(:,end));
if V_max_out < eps
    V_max_out = 0;
end

% Here, now, is the total change in partial concentrations across
% the board, accounting for mechanical combination and divergence
diff_mech = diff_mech - diffadv;