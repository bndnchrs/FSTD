% function makemovie_jointdist(fileloc)
fileloc = name;


load(fileloc,'psisave','Lambda','bret_ampl');

load(fileloc,'concsave');

load(fileloc,'fulldiff*');
% diffswell = squeeze(sum(fulldiffswell,2));

load(fileloc,'bret_spec','wattensave','tauswellsave');
load(fileloc,'R');
load(fileloc,'time','year','day');

load(fileloc,'Rmeanarea','mesh*','TotVol');
load(fileloc,'H','HMSAVE');

tick_frac = [-0.0585    0.0248    0.1081    0.1914    0.2747    0.3580    0.4417    0.5250    0.6083    0.6916    0.7749    0.8582]; 
ticks = tick_frac + 0; 
%% Calculate Some Things


for ii = 1:length(HMSAVE)
    SAsave(ii) = 0*concsave(ii) + integrate_FD(psisave(:,:,ii),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
end

figure('units','inches','Position',[0 0 24 12])

subplot('Position', [0.1300    0.1100    0.4953    0.5153])
contour(meshH,meshR,log10(squeeze(psisave(:,:,1))+eps),linspace(-10,-1,10),'k','showtext','on','textlist',[-9 -7 -5 -3 -1]);

AX(1) = gca;

splot = [1 2 3 6 9];
plotter = [concsave;
    TotVol + Volex;
    Rmeanarea;
    HSAVE;
    Q_surf(1:length(time)); ];
pnames = {'Ice Concentration','Ice Volume','Mean Floe Size','Ice Thickness','Heat Flux'};
ylabs = {'%','m^3/m^2','m','m','W/m^2'};
strs = {'(a)','(b)','(c)','(e)','(f)','(d)'};

%%
for i = 1:length(splot)
    
    clear stormplot
    
    AX(i+1) = subplot(3,3,splot(i));
    plot(time/year,plotter(i,:),'k');
    grid on
    % xlim(lims)
    set(gca,'xtick',ticks,'xticklabel',xlab,'FontName','Lucida Sans','FontSize',8);
    ylabel(ylabs{i})
    title(pnames{i});
    hold on
    yl = get(gca,'ylim');
    
    g{i} = scatter(AX(i+1),time(1)/year,plotter(i,1),300,'r');
    stormplot = stormy(1,1:length(time))*max(yl)/4;
    
    bar(time/year,stormplot,'FaceColor','g','EdgeColor','g');
    posy = get(gca,'Position');
    annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{i},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
    
end


for ii = 1:4*7:length(time)
    
    
    yr = ceil(time(ii)/year);
    if yr > 1
        lims = [tick_frac(1)+yr-1 tick_frac(1)+yr];
        ticks = tick_frac + yr-1; 
    else
        lims = [tick_frac(1) tick_frac(1)+1];
        ticks = tick_frac; 
    end
    
    contour(AX(1),[H HMSAVE(1)],R,log10(squeeze(psisave(:,:,ii))+eps),linspace(-10,-1,10),'k','showtext','on','textlist',[-7 -5 -3 -1]);
    title('Joint Distribution')
    xlabel('Thickness (m)');
    ylabel('Floe Size (m)');
    %%
    for i = 1:length(splot)
        
        % Scatter values
        delete(g{i});
        
        clear stormplot
        
        subplot(3,3,splot(i));
        g{i} = scatter(AX(i+1),time(ii)/year,plotter(i,ii),300,'r');
        xlim(lims);
        set(gca,'xtick',ticks,'xticklabel',xlab,'FontName','Lucida Sans','FontSize',8);
  
        
    end
    
    
    
    drawnow
    
end

