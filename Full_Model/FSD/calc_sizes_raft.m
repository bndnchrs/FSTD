function [S, Kfac, Prob_Interact,Kstar] = calc_sizes_raft(R,maxr,A_tot)

% Calculates the location of the new floe formed by interactions of floes
% of sizes R subject to interaction int

S = zeros(length(R),length(R)); 
Prob_Interact = S; 
Kfac = 1 + S; 

        
for i = 1:length(R)
    for j = 1:length(R)
        
        %%
        
        d = min(R(i),R(j)); 
        s = max(R(i),R(j)); 
        
        if d^2 < maxr^2/2
            rnew = sqrt(s^2);
        else 
            rnew = sqrt(s^2 + d^2 - maxr^2/2); 
        end
        
        [~, loc] = min(abs(R - rnew));
        loc  = max([i+1,j+1,loc]);
        min(loc,length(R));
        S(i,j) = min(loc,length(R)); 
        
        if loc == length(R)
            Kfac(i,j) = (rnew^2/R(loc)^2);
        end
        Kstar(i,j) = Kfac(i,j)*R(S(i,j))^2 / (R(i)^2 + R(j)^2);
        
        if Kstar(i,j) > 1
            Kfac(i,j) = (rnew^2/R(loc)^2);
            Kstar(i,j) =  Kfac(i,j)*R(S(i,j))^2 / (R(i)^2 + R(j)^2);
        end
          
        
        
        
        % Smaller floe is some part contact zone, d + d_cr + delta
        % Delta is width of contact zone
        
        if d > maxr
            % If bigger than raft size, delta is the difference
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
      
        
        num = acz_d*acz_s; 
        denom = (A_tot - acore_s - acore_d)^2; 
        Prob_Interact(i,j) = A_tot^2*num/denom; 
        
    end
end

%%
% ind = linspace(1,length(R),length(R)); 
% [ind ind] = meshgrid(ind,ind); 
% depmat = S - ind; 
% depmat = depmat(1:end-1,1:end-1); 
% 
% if min(min(depmat)) <= 0
%     depmat(depmat <= 0) = NaN;
%     pcolor(depmat)
%     disp('Gotta Rework'); 
%     return
% end


% Prob_Interact = Prob_Interact / sum(Prob_Interact(:)); 
