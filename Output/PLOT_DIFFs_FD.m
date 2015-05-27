% function makemovie_jointdist(fileloc)
fileloc = name;
addpath('./Movies')

load(fileloc,'psisave','Lambda','bret_ampl');

load(fileloc,'concsave');

load(fileloc,'fulldiff*');
% diffswell = squeeze(sum(fulldiffswell,2));

load(fileloc,'bret_spec','wattensave','tauswellsave');
load(fileloc,'R');
load(fileloc,'time','year','day');

load(fileloc,'Rmeanarea','mesh*','TotVol');
load(fileloc,'H','HMSAVE');
%%
tick_frac = [-0.0585    0.0248    0.1081    0.1914    0.2747    0.3580    0.4417    0.5250    0.6083    0.6916    0.7749    0.8582]; 

tfrac = tick_frac(1):.0833:time(end)/year;

tl = cell2mat(xlab); 

tl = repmat(tl,[1 ceil(time(end)/year)]); 
tl = mat2cell(tl',300);
ticks = tick_frac + 0; 
%% Calculate Some Things


for ii = 1:length(HMSAVE)
    SAsave(ii) = 0*concsave(ii) + integrate_FD(psisave(:,:,ii),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
end

figure('units','inches','Position',[0 0 8.5 6])


splot = [1 2 3];
plotter = [concsave;
    TotVol + Volex;
    HSAVE;];

diffplot = {fulldiffsave,fulldiffthermo,fulldiffmech,fulldiffswell}; 

pnames = {'Ice Concentration','Ice Volume','Ice Thickness','Heat Flux'};
ylabs = {'%','m^3/m^2','m','m','W/m^2'};
strs = {'(a)','(b)','(c)','(e)','(f)','(d)'};

%%
for i = 1:length(splot)
    
    clear stormplot
    
    AX(i) = subplot(2,4,splot(i));
    plot(time/year,plotter(i,:),'k');
    grid on
    xlim(lims)
    ylabel(ylabs{i})
    title(pnames{i});
    hold on
    yl = get(gca,'ylim');
    
    g{i} = scatter(AX(i),time(1)/year,plotter(i,1),300,'r');
    stormplot = stormy(1,1:length(time))*max(yl)/4;
    set(gca,'xtick',ticks,'xticklabel',xlab,'FontName','Lucida Sans','FontSize',8);

    bar(time/year,stormplot,'FaceColor','g','EdgeColor','g');
    posy = get(gca,'Position');
   % annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{i},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
    
end

% for j = 1:4
%     AX2(j) = subplot(2,4,4+j); 
%     [C h{j}] = contour(AX2(j),[H HMSAVE(1)],R,log10(abs(day*squeeze(diffplot{j}(:,:,1))+eps)),linspace(-10,-1,10),'k','showtext','on','textlist',[-7 -5 -3 -1]);
% end

%%
 yr = ceil(time(ii)/year);
    if yr > 1
        lims = [tick_frac(1)+yr-1 tick_frac(1)+yr];
        ticks = tick_frac + yr-1; 
    else
        lims = [tick_frac(1) tick_frac(1)+1];
        ticks = tick_frac; 
    end
    
    limbot = lims; 
    
create_movie_FD([name '_FSDITD'],1,[0 0 10 10])


for ii = 1:4*7:length(time)
%%
    yr = ceil(time(ii)/year);
    if yr > 1
        lims = [tick_frac(1)+yr-1 tick_frac(1)+yr];
        ticks = tick_frac + yr-1; 
    else
        lims = [tick_frac(1) tick_frac(1)+1];
        ticks = tick_frac; 
    end
    
    limbot = [time(ii)/year - 1 time(ii)/year];
    if limbot(1) < 0
        limbot = [0 1];
    end
    
    for i = 1:length(splot)
        
        % Scatter values
        delete(g{i});
        
        clear stormplot
        
        subplot(2,4,splot(i));
        g{i} = scatter(AX(i),time(ii)/year,plotter(i,ii),300,'r');
        xlim(limbot);
        set(gca,'xtick',tfrac,'xticklabel',tl,'FontName','Lucida Sans','FontSize',8);
  
        
    end
    
%     for j = 1:4
%         delete(h{j}); 
%         subplot(2,4,j+4)
%         [C h{j}] = contour(AX2(j),[H HMSAVE(1)],R,log10(abs(day*squeeze(diffplot{j}(:,:,ii))+eps)),linspace(-18,-1,10),'k','showtext','on','textlist',[-7 -5 -3 -1]);
%     end
    
    subplot('Position', [0.1300    0.1100    0.3347    0.3412])
    cla
    i = ii; 
    FD_TOTALDIFF; 
    legend({'Pancake Ice','Thermodynamics','Mechanics','Wave Fracture'})
    limbot = [time(ii)/year - 1 time(ii)/year];
    if limbot(1) < 0
        limbot = [0 1];
    end
    xlim(limbot)
    set(gca,'xtick',tfrac,'xticklabel',tl,'FontName','Lucida Sans','FontSize',8);
    grid on
    title('Volume Change Per day')
    ylabel('V per day')
    % annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{ii+1},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
    ylim([0 1e-2])
    
    subplot(2,2,4) 
    
    contourf([H HMSAVE(1)],R,log10(psisave(:,:,ii)+eps),[-100 -10:1:-1],'k','showtext','on','textlist',[-8 -6 -4 -2]); xlabel('Ice Thickness'); ylabel('Floe Size'); grid on

    set(gca,'FontName','Lucida Sans','FontSize',8);
    grid on
    xlabel('Thickness')
    ylabel('Size')
    title('FSD/ITD')
    
      
    tittel = round(time(i)/year+1);
    
    tittel = (['Year ',num2str(tittel)]);
    d4 = annotation('textbox',[.475 .935 .6 .05],'String',tittel,'LineStyle','none','FontName','Lucida Sans','FontSize',8)

    ylim([R(1) R(end)])
    xlim([H(1) HMSAVE(1)])
    
    drawnow
    
        create_movie_FD([name '_ALL'],ii,[0 0 10 10])

        delete('d4')
    
end


    create_movie_FD('close',ii,[0 0 10 10])

