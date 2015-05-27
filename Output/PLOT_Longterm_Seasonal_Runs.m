% PLOT_Longterm_Seasonal_Runs
close all
clear all

name = '../SavedOutput/';
name = [name 'Full_Runs/FullModel_2weekstorm_bigger.mat']; 

load(name,'time','dt','day','fulldiff*','do_*','meshH','pansave','meshR','R','H','HMSAVE','year','stormy','HSAVE','concsave','TotVol','Volex','VSAVE','Rmean*','Q_surf','psisave')


addpath('../Utilities')
addpath('../Output/')

f1 = figure;

xlab = {'S','O','N','D','J','F','M','A','M','J','J','A'};
ticks = [23.9415 24.0248 24.1081 24.1914 24.2747 24.3580 24.4417 24.5250 24.6083 24.6916 24.7749 24.8582];
lims = [23.9315 24.9315];
lims = lims - 20;
ticks = ticks - 20; 
splot = [1 2 3];
plotter = [concsave;
    TotVol + Volex;
    HSAVE;];
pnames = {'Ice Concentration','Ice Volume','Ice Thickness','Heat Flux'};
ylabs = {'%','m^3/m^2','m','m','W/m^2'};
strs = {'(a)','(b)','(c)','(d)'};

%%
for ii = 1:length(splot)
    
%    clear stormplot
    
    subplot(3,3,splot(ii));
    plot(time/year,plotter(ii,:),'k');
    grid on
    xlim(lims)
    set(gca,'xtick',ticks,'xticklabel',xlab,'FontName','Lucida Sans','FontSize',8);
    ylabel(ylabs{ii})
    title(pnames{ii});
    hold on
    yl = get(gca,'ylim');
    
    
    stormplot = stormy(1,1:length(time))*max(yl)/4;
    
    bar(time/year,stormplot,'FaceColor','g','EdgeColor','g');
    posy = get(gca,'Position');
    annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{ii},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
end

subplot('Position', [0.1300    0.1100    0.7750    0.5153])

i = round(min(ticks)+1)*365*4;
%%
FD_TOTALDIFF;
legend({'Pancake Ice','Thermodynamics','Mechanics','Wave Fracture'})
xlim(lims)
set(gca,'xtick',ticks,'xticklabel',xlab,'FontName','Lucida Sans','FontSize',8);
grid on
title('Volume Change Per day')
ylabel('V per day')
 posy = get(gca,'Position');
    annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{ii+1},'LineStyle','none','FontName','Lucida Sans','FontSize',8)

pos = [0 0 8.5 4];
set(gcf,'units','inches','windowstyle','normal','Position',pos,'PaperPosition',pos,'PaperSize',pos(3:4)); 

saveas(gcf,'~/Dropbox/Chris_FSD/FSD_Paper/Figures/Longterm_Run.pdf'); 
saveas(gcf,'~/Dropbox/Chris_FSD/FSD_Paper/Figures/Longterm_Run.fig');
%%
figure;

psifall = psisave(:,:,1:365*4:end);
psiwin = psisave(:,:,366:365*4:end);
psispring = psisave(:,:,365*2+1:365*4:end);
psisum = psisave(:,:,365*3+1:365*4:end);

PS{1} = squeeze(mean(psifall(:,:,15:end),3));
PS{2} = squeeze(mean(psiwin(:,:,15:end),3));
PS{3} = squeeze(mean(psispring(:,:,15:end),3));
PS{4} = squeeze(mean(psisum(:,:,15:end),3));

tits = {'Sep 21','Dec 21','Mar 21','Jul 21'};
cols = {'k','b','g','r'};


strs = {'(a)','(b)','(c)','(d)','(e)','(f)'};

%%

for ii = 1:4
    
    subplot(2,2,1)
    hold on
    % FSD
    loglog(R,squeeze(sum(PS{ii},2)),cols{ii});
    set(gca,'FontName','Lucida Sans','FontSize',8,'YScale','log','XScale','log');
    grid on
    
    if ii == 4
        legend(tits);
         posy = get(gca,'Position');
         annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{1},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
         xlim([R(1) max(R)])
         xlabel('Floe Size')
    end
    
    subplot(2,2,2)
    hold on
    % ITD
    semilogy([H HMSAVE(1)],squeeze(sum(PS{ii},1)),cols{ii})
    set(gca,'FontName','Lucida Sans','FontSize',8,'Yscale','log');
    grid on
    
    if ii == 4
        legend(tits);
        posy = get(gca,'Position');
         annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{2},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
        xlim([H(1) HMSAVE(1)])
        xlabel('Ice Thickness')
    end
    
    subplot(2,4,4+ii)
    contour([H HMSAVE(1)],R,log10(PS{ii}+eps),[-100 -10:1:-1],'k','showtext','on','textlist',[-8 -6 -4 -2]); xlabel('Ice Thickness'); ylabel('Floe Size'); grid on
    set(gca,'FontName','Lucida Sans','FontSize',8);
    grid on
    xlabel('Thickness')
    ylabel('Size')
    title(tits{ii})
    
    ylim([R(1) 80])
    xlim([H(1) HMSAVE(1)])
    
    posy = get(gca,'Position');
    annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{ii+2},'LineStyle','none','FontName','Lucida Sans','FontSize',8)

    
end
%%
pos = [0 0 8.5 4];
set(gcf,'units','inches','windowstyle','normal','Position',pos,'PaperPosition',pos,'PaperSize',pos(3:4)); 
% saveas(gcf,'~/Dropbox/Chris_FSD/FSD_Paper/Figures/Longterm_Marginal.fig'); 
% saveas(gcf,'~/Dropbox/Chris_FSD/FSD_Paper/Figures/Longterm_Marginal.pdf'); 

