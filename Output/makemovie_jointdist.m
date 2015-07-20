% function makemovie_jointdist(fileloc)
fileloc = '../../FSTD-OUTPUT/FullModel_NoMerge';


load(fileloc,'DIAG','FSTD','OPTS','EXFORC');


tick_frac = [-0.0585    0.0248    0.1081    0.1914    0.2747    0.3580    0.4417    0.5250    0.6083    0.6916    0.7749    0.8582]; 
ticks = tick_frac + 0; 
xlab = {'S','O','N','D','J','F','M','A','M','J','J','A'};

%% Calculate Some Things

% 
% for ii = 1:length(DIAG.H)
%     DIAG.SA(ii) = 0*DIAG.concsave(ii) + integrate_FD(psisave(:,:,ii),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
% end

figure('units','inches','Position',[0 0 24 12])

% subplot('Position', [0.1300    0.1100    0.4953    0.5153])
contour(FSTD.meshH,FSTD.meshR,log10(squeeze(DIAG.psi(:,:,1))+eps),linspace(-10,-1,10),'k','showtext','on','textlist',[-9 -7 -5 -3 -1]);

AX(1) = gca;


%%
splot = [1 2 3 6 9];
plotter = [DIAG.conc;
    DIAG.V_tot;
    DIAG.Rmeanarea;
    DIAG.H;
    DIAG.Q_ocean(1:length(FSTD.time)); ];
pnames = {'Ice Concentration','Ice Volume','Mean Floe Size','Ice Thickness','Heat Flux'};
ylabs = {'%','m^3/m^2','m','m','W/m^2'};
strs = {'(a)','(b)','(c)','(e)','(f)','(d)'};
% xlab = 'Time'
splot = []; 
%%
for i = 1:length(splot)
    
    clear stormplot
    
    AX(i+1) = subplot(3,3,splot(i));
    plot(FSTD.time/OPTS.year,plotter(i,:),'k');
    grid on
    % xlim(lims)
    set(gca,'xtick',ticks,'xticklabel',xlab,'FontName','Lucida Sans','FontSize',8);
    ylabel(ylabs{i})
    title(pnames{i});
    hold on
    yl = get(gca,'ylim');
    
    g{i} = scatter(AX(i+1),FSTD.time(1)/OPTS.year,plotter(i,1),300,'r');
    stormplot = EXFORC.stormy(1,1:length(FSTD.time))*max(yl)/4;
    
    bar(FSTD.time/OPTS.year,stormplot,'FaceColor','g','EdgeColor','g');
    posy = get(gca,'Position');
    annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{i},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
    
end
%%

for ii = 1:4:length(FSTD.time)
    
    
    yr = ceil(FSTD.time(ii)/OPTS.year);
    if yr > 1
        lims = [tick_frac(1)+yr-1 tick_frac(1)+yr];
        ticks = tick_frac + yr-1; 
    else
        lims = [tick_frac(1) tick_frac(1)+1];
        ticks = tick_frac; 
    end
    
    contour(AX(1),[FSTD.H FSTD.H(end)+OPTS.dh],FSTD.R,log10(squeeze(DIAG.psi(:,:,ii))+eps),linspace(-10,-1,10),'k','showtext','on','textlist',[-7 -5 -3 -1]);
    title('Joint Distribution')
    xlabel('Thickness (m)');
    ylabel('Floe Size (m)');
    %%
    for i = 1:length(splot)
        
        % Scatter values
        delete(g{i});
        
        clear stormplot
        
        subplot(3,3,splot(i));
        g{i} = scatter(AX(i+1),FSTD.time(ii)/OPTS.year,plotter(i,ii),300,'r');
        xlim(lims);
        set(gca,'xtick',ticks,'xticklabel',xlab,'FontName','Lucida Sans','FontSize',8);
  
        
    end
    
    
    
    drawnow
    
end

