function [S, Kfac, Prob_Interact,Kstar] = calc_sizes_ridge(R,maxr,A_tot,k_ridge)

% Calculates the location of the new floe formed by ridging of floes
% of sizes Rt and the likelihood of interaction

S = zeros(length(R),length(R));
Prob_Interact = S;
Kfac = 1 + S; 

for i = 1:length(R)
    for j = 1:length(R)
        
        
        %% Interaction Probability
        
        d = min(R(i),R(j));
        s = max(R(i),R(j));
        
        % Bigger Floe and Smaller floe have a fixed-width contact zone.
        
        if d > maxr
            % If bigger than ridge size, delta is the difference
            delta_d = maxr;
        else
            % Otherwise width is the whole thing
            delta_d = d;
        end
        
        % Core is the non-delta part
        acore_d = (d - delta_d)^2;
        % Contact zone is the rest
        acz_d = d^2 - acore_d;
        
        % Bigger floe has same radius contact zone
        
        acore_s = (s - delta_d)^2;
        acz_s = s^2 - acore_s;
        
        if s > maxr
            acore_s = s^2 - maxr^2;
            acz_s = maxr^2;
        else
            acore_s = 0;
            acz_s = s^2;
        end
        
        Prob_Interact(i,j) = A_tot^2*(acz_d*acz_s)/(A_tot - acore_s - acore_d)^2;
        
        
        %% Area Loss
        
        % Ridge is fixed multiple of initial thickness of small floe.
        
        Anew = s^2 + d^2 - (1 - 1/k_ridge)*acz_d;
        rnew = sqrt(Anew);
        
        [~, loc] = min(abs(R - rnew));
        loc  = max([i+1,j+1,loc]);
        loc = min(loc,length(R));         
        S(i,j) = loc;
        
        % Adjustment for floes getting too big
        if loc == length(R)
            Kfac(i,j) = (rnew^2/R(loc)^2);
        end
        Kstar(i,j) = Kfac(i,j)*R(S(i,j))^2 / (R(i)^2 + R(j)^2);
        
        if Kstar(i,j) > 1
            Kfac(i,j) = (rnew^2/R(loc)^2);
            Kstar(i,j) =  Kfac(i,j)*R(S(i,j))^2 / (R(i)^2 + R(j)^2);
        end

    end
end

% Prob_Interact = Prob_Interact / sum(Prob_Interact(:));

