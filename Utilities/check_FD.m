function check_FD
%% FD_Check
% This routine checks for errors in the code. It also outputs required or
% requested information to the command line.
global FSTD
global OPTS


if FSTD.H_max < 0
    error('Negative H')
end

if sum(FSTD.psi(:)) > 1
    disp('Too much conc')
    FSTD.i
    error(1)
end

if isnan(FSTD.psi)
    disp('NaNned out')
    FSTD.i
    error(1)
end

if abs(FSTD.opening + sum(FSTD.diff(:))) > eps
    disp('Bad Opening/Closing')
    error(1)
end

if min(FSTD.psi(:)) < 0
    disp(FSTD.i)
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

if mod(FSTD.i,OPTS.nt/10) == 0
    
    fprintf('%d Percent Complete. %d timesteps. %d subcycles \n',round(100*FSTD.i/OPTS.nt),FSTD.i,OPTS.totnum)
    
end



if mod(FSTD.i,OPTS.year/OPTS.dt) == 0
    
    % fprintf('Year %d of %d \n',FSTD.i*OPTS.dt/OPTS.year,round(OPTS.nt*OPTS.dt/OPTS.year))
    % ITD = squeeze(sum(psi,1));
    % plot(log(ITD+eps));
    
    %pcolor(log(psi + eps))
    %caxis([-18 0])
    % shading interp
    % colorbar
    % drawnow
end