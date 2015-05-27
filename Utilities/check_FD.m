%% FD_Check
% This routine checks for errors in the code. It also outputs required or
% requested information to the command line.

if H_max < 0
    error('Negative H')
end

if isnan(psi)
    disp('NaNned out')
    i
    error(1)
end

if abs(opening + sum(diff_FD(:))) > eps
    disp('Bad Opening/Closing')
    error(1)
end

if min(psi(:)) < 0
    disp(i)
    error('Less Than Zero after cutting')
end

%     if i > 1
%         if TotVol(i) - TotVol(i-1) > 1e-6
%             error('Losing Volume');
%         end
%     end

%% Text Output

%     if numSC > 1
%         fprintf(' %d subcycles. \n',numSC);
%     end


%% Plotting

if mod(i,nt/10) == 0
    
    fprintf('%d Percent Complete. %d timesteps. %d subcycles \n',round(100*i/nt),i,totnum)
    
end



if mod(i,year/dt) == 0
    
    fprintf('Year %d of %d \n',i*dt/year,round(nt*dt/year))
    % ITD = squeeze(sum(psi,1));
    % plot(log(ITD+eps));
    
    %pcolor(log(psi + eps))
    %caxis([-18 0])
    % shading interp
    % colorbar
    % drawnow
end