function makemovie_swell_FSD(fileloc)

load(fileloc,'psisave','Lambda','bret_ampl');

load(fileloc,'concsave');

load(fileloc,'fulldiffswell');
% diffswell = squeeze(sum(fulldiffswell,2));

load(fileloc,'bret_spec','wattensave','tauswellsave');
load(fileloc,'R');
load(fileloc,'time','year','day');

load(fileloc,'Rmeanarea');
load(fileloc,'H','HMSAVE');

%% Calculate Some Things

FSD = squeeze(sum(psisave,2));
diffswell = squeeze(sum(fulldiffswell,2));


for ii = 1:length(HMSAVE)
    SAsave(ii) = 0*concsave(ii) + integrate_FD(psisave(:,:,ii),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
end

% figure('units','inches','Position',[0 0 24 12])

%%

subplot('Position', [0.1300    0.7093    0.4942    0.2091]);
[AX0,H0,H2] = plotyy(R,FSD(:,1)/sum(FSD(:,1)),Lambda,bret_spec/max(bret_spec));
A2 = subplot('Position',[0.6916    0.7093    0.2134    0.2157]); 
set(A2,'Ylim',[-1e-2 1e-2])

hold(AX0(2),'on')
plot(AX0(2),R,cumsum(bret_spec/sum(bret_spec))); 


legend({'FSD (initial)','Wave Spectrum(normalized)','Cumulative Spectrum','FSD'})
grid on
hold(A2,'on')
xlabel(A2,'Size (m)')
ylabel(A2,'Relative Area Change')

AX(2) = subplot(3,3,4);
AX(3) = subplot(3,3,5);
AX(4) = subplot(3,3,6);

subplot(3,1,3);
[BX0,H0,H2] = plotyy(R,wattensave(:,1)/1e4,R,tauswellsave(:,1)/3600);

hold(BX0(1),'on')
xlabel(BX0(1),'Wavelength (m)')

set(BX0(1),'YScale','linear','LineWidth',2,'FontSize',24)
set(BX0(1),'YTick',[0 .5 1])
set(BX0(2),'YScale','linear','LineWidth',2,'FontSize',24)
set(BX0(1),'Ylim',[0 1])
set(BX0(2),'Ylim',[0 6])
set(BX0(2),'YTick',[0 3 6])
set(BX0(1),'Xlim',[0 R(end)],'YMinorTick','off')
grid on
title(BX0(1),'Attenuation Fraction (% of Grid')
grid(BX0(1),'on')
legend({'Atten. Frac.','Wave Pen. Timescale (hours)'})


hold(AX0(1),'on')

xlabel(AX0(1),'Size (m)')

%set(AX0(1),'YScale','linear','LineWidth',2,'FontSize',24)
set(AX0(1),'Ylim',[0 .2])
set(AX0(1),'YTick',[0 .05 .1 .15 .2])
% grid on
set(AX0(1),'Xlim',[0 R(end)])
set(AX0(2),'Xlim',[0 R(end)])
set(AX0(2),'Ylim',[0 1])
title(AX0(1),'Floe Size Distribution')
grid(AX0(1),'on')


hold(AX(2),'on');
set(AX(2),'LineWidth',2,'FontSize',16,'xlim',[0 time(end)/day])
title(AX(2),'Mean Floe Size')
grid(AX(2),'on')
xlabel(AX(2),'Time (days)')
plot(AX(2),time/day,Rmeanarea,'k','LineWidth',1)

hold(AX(3),'on');
set(AX(3),'LineWidth',2,'FontSize',16,'xlim',[0 time(end)/day])
title(AX(3),'Total Floe Surface Area')
grid(AX(3),'on')
xlabel(AX(3),'Time (days)')
plot(AX(3),time/day,SAsave,'k','LineWidth',1)

hold(AX(4),'on');
set(AX(4),'LineWidth',2,'FontSize',16,'xlim',[0 time(end)/day])
title(AX(4),'Total Area Change per day')
grid(AX(4),'on')
xlabel(AX(4),'Time (days)')
plot(AX(4),time/day,squeeze(sum(sum(abs(fulldiffswell(:,:,2:end)),1),2))/2,'k','LineWidth',1)

clear H0

% for ii = 1:length(time)
% 
% 
% %%
% % This plots with the thermo on the right axis    
%     if exist('h0','var')
%         delete(h0)
%     end
%     if exist('h2','var')
%         
%         delete(h2)
%     end
%     if exist('h3','var')
%         
%         delete(h3)
%     end
%     if exist('g1','var')
%         
%         delete(g1)
%     end
%     
%     if exist('g2','var')
%         
%         delete(g2)
%     end
%     
%     if exist('HH0','var')
%         
%         delete(HH0)
%     end
%     
%     ff = FSD(:,ii)/sum(FSD(:,ii));
%     
%     dd = ff.*diffswell(:,ii)./(ff * sum(abs(diffswell(:,1))));
%     dd1 = ff.*diffswell(:,1)./(ff * sum(abs(diffswell(:,1))));
%     
%    % dd = dd - min(dd1); 
%     
%     h0 = plot(AX0(1),R,ff,'k','LineWidth',2);
%     h2 = plot(A2,R,dd,'g','LineWidth',2);
%     
%     h3 = scatter(AX(2),time(ii)/day,Rmeanarea(ii),300,'r','filled');
%     
%     g1 = scatter(AX(3),time(ii)/day,SAsave(ii),300,'r','filled');
%     
%     g2 = scatter(AX(4),time(ii)/day,squeeze(sum(sum(abs(fulldiffswell(:,:,ii+1)),1),2))/2,300,'r','filled');
%     
%     HH0 = plot(BX0(1),R,wattensave(:,ii)/1e4,'k','LineWidth',6);
%     
%     drawnow
%     
% end


end