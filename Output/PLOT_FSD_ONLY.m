% PLOT_FSD_THERMO

close all

load('SavedOutput/AnnDiurn/AnnDiurn.mat','psisave');
psAD = psisave; 



load('SavedOutput/AnnDiurn/AnnDiurn.mat','concsave');
concAD = concsave; 

load('SavedOutput/AnnDiurn/AnnOnly.mat','psisave');
psAO = psisave; 


load('SavedOutput/AnnDiurn/AnnOnly.mat','concsave');
concAO = concsave; 

load('SavedOutput/AnnDiurn/AnnOnly.mat','R');
load('SavedOutput/AnnDiurn/AnnOnly.mat','time','year');


load('SavedOutput/AnnDiurn/AnnDiurn.mat','Q_surf');
Q_surf_D = Q_surf; 
load('SavedOutput/AnnDiurn/AnnOnly.mat','Q_surf');


% [AX,H1,H2] = plotyy(R,psAD(:,1,i),70,Q_surf(i));

AX(1) = subplot(2,1,1);
AX(2) = subplot(2,2,3);
AX(3) = subplot(2,2,4);

h0 = plot(AX(1),psAD(:,1,1),'k','LineWidth',6); 
hold(AX(1),'on')
h1 = plot(AX(1),psAO(:,1,1),'r','LineWidth',6); 
scatter(AX(2),70,Q_surf(1)); 

set(AX(1),'YScale','log','LineWidth',2,'FontSize',24)
set(AX(1),'Ylim',[1e-6 1])
set(AX(1),'Xlim',[0 R(end)],'YTick',[1e-6 1e-4 1e-2 1e-1],'YMinorTick','off')
grid on
hold(AX(2),'on');
set(AX(2),'Xlim',[0 1],'YTick',[-400 -200 0 200 400],'XTick',[0 .25 .5 .75 1],'LineWidth',2,'FontSize',16)
grid(AX(1),'on')
title(AX(2),'Surface Heat Flux')
title(AX(1),'Floe Size Distribution')
grid(AX(2),'on')

xlabel(AX(2),'Time (years) of season')

legend(AX(1),{'Diurnal Cycle','No Diurnal Cycle'},'FontSize',24)
plot(AX(2),time(1:365*24)/year,Q_surf_D(1:365*24),'k','LineWidth',1)


plot(AX(2),time(1:365*24)/year,Q_surf(1:365*24),'r','LineWidth',6)



 plot(AX(3),time(1:365*24)/year,concAD(end-365*24:end-1),'k','LineWidth',6);
hold(AX(3),'on')
 plot(AX(3),time(1:365*24)/year,concAO(end-365*24:end-1),'r','LineWidth',6);

 set(AX(3),'Xlim',[0 1],'YTick',[0 .5 1],'XTick',[0 .25 .5 .75 1],'LineWidth',2,'FontSize',16)
 title(AX(3),'Concentration')
 grid(AX(3),'on')
 xlabel(AX(3),'Time (years) of season')


%%
% This plots with the thermo on the right axis
for i = 1:24:max(size(psAD))
    
h0 = plot(AX(1),R,psAD(:,1,i),'k','LineWidth',6);
    
h1 = plot(AX(1),R,psAO(:,1,i),'r','LineWidth',6);

h3 = scatter(AX(2),mod(time(i)/year,1),Q_surf(i),300,'r','filled');

g0 = scatter(AX(3),mod(time(i)/year,1),concAD(i),300,'k','filled');

g1 = scatter(AX(3),mod(time(i)/year,1),concAO(i),300,'r','filled');

set(AX(2),'Ylim',[-450 450])

drawnow

delete(h0)
delete(h1)
delete(h3)
delete(g0)
delete(g1)



% hold(AX(1),'off');
% hold(AX(2),'off');


end