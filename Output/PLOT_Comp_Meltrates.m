Outnames = {'SavedOutput/AnnDiurn/Sens/FL1.mat',...
    'SavedOutput/AnnDiurn/Sens/FL2.mat',...
    'SavedOutput/AnnDiurn/Sens/FL3.mat',...
    'SavedOutput/AnnDiurn/Sens/FL6.mat',...
    'SavedOutput/AnnDiurn/Sens/FL7.mat',...
    'SavedOutput/AnnDiurn/Sens/FL9.mat', ...
    'SavedOutput/AnnDiurn/AnnDIurn.mat'};

AX(1) = subplot(1,3,1);
set(AX(1),'YScale','linear','LineWidth',2,'FontSize',24)
set(AX(1),'Xlim',[1 2],'YMinorTick','off')
title(AX(1),'Ice Concentration')


AX(2) = subplot(1,3,2);
set(AX(2),'YScale','linear','LineWidth',2,'FontSize',24)
set(AX(2),'Xlim',[1 2],'YMinorTick','off')
title(AX(2),'Lateral Melt/Growth Rates')

AX(3) = subplot(1,3,3);
set(AX(3),'YScale','linear','LineWidth',2,'FontSize',24)
set(AX(3),'Xlim',[1 2],'YMinorTick','off')
title(AX(3),'Total Volume')


hold(AX(1),'on')
grid(AX(1),'on')
hold(AX(2),'on')
grid(AX(2),'on')
hold(AX(3),'on')
grid(AX(3),'on')

for i = 1:length(Outnames)
    load(Outnames{i},'concsave','drdtsave','Volex','time')
    plot(AX(1),time/year,smooth(concsave,24),'linewidth',6)
    plot(AX(2),time/year,smooth(drdtsave,24),'linewidth',6)
    plot(AX(3),time/year,smooth(Volex,24),'linewidth',6)
    
end
    
set(AX(2),'Ylim',[min(drdtsave),max(drdtsave)])
legend(AX(1),{'10%','20%','30%','60%','70%','90%','"real"'})
