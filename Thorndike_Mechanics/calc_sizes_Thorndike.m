function [S_H,Kfac] = calc_sizes_Thorndike(H,k)

% Calculates the location of the new floe formed by rafting of floes
% of sizes Rt and the likelihood of interaction

for i = 1:length(H)
    
    H_new = k*H(i);
    [~, loc] = min(abs(H - H_new));
    loc  = max([i+1,loc]);
    loc = min(loc,length(H));
    S_H(i) = loc; 
    % Want to conserve volume.
    Kfac(i) = H(i)/H(loc);
    
end

end
