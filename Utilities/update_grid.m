% This routing updates the grids which contain the details of the largest
% floe size as well as the ridging/rafting coefficients, and the volume of
% each floe category. It is updated at each timestep to reflect the changes
% to the largest thickness category.

% Most of this is not needed, we must merely update the last row of meshH.
% Since it doesn't take too much computing time, we will do it each
% timestep anyways. Consider for refining later.

[meshR,meshH] = meshgrid(R,[H H_max]);
meshR = meshR';
meshH = meshH';
meshV = pi*meshR.^2 .* meshH;

if do_Mech == 1
    
    gamma_ridge = calc_gamma_ridge_FD([H H_max],meshH,H_raft);
    gamma_raft = 1 - gamma_ridge;
    
end

