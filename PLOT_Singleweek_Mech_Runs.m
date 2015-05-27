% PLOT SingleWeek Mech Runs

Outnames = {'SavedOutput/OneWeekmech/Compressing_swapgamma','SavedOutput/OneWeekmech/Shear_swapgamma'}
strs = {'(a)','(b)','(c)','(d)'}
for III = 1:2
    
    load(Outnames{III});
    
    
    %%
        subplot(2,4,4*(III-1) + 1)

    plot(time/day,concsave/concsave(1),'k');
    hold on
    plot(time/day,HSAVE/HSAVE(1),'b');
    plot(time/day,(VSAVE + VMSAVE)/(VSAVE(1) + VMSAVE(1)),'r');
    posy = get(gca,'Position');
    annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{2*(III - 1) + 1},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
 
    ylim([.4 2])
    grid on
    
    legend({'Conc.','Thickness','Volume'}); 
    set(gca,'FontSize',8,'FontName','Lucida Sans')
    xlim([time(1)/day time(end)/day])
    if III == 1
        xlabel('Time (days)')
        title('Convergence Only')
    end
    if III == 2
        title('Shear Only')
    end
    ylabel('Multiple of Initial')
    
    
    ARG = squeeze(psisave(:,:,1)+eps);
    subplot(2,4,4*(III-1) + 2)
    cla
    contourf([H HMSAVE(1)],R,log10(ARG),[-100 -12:1:-2],'showtext','on','textlist',[-8 -6 -4 -2])
    xlim([H(1) HMSAVE(1)])
    ylim([R(1) R(end)])
    shading interp
    colormap jet
    grid on
  %  set(gca,'clim',[-12 -2])
    if III == 1
        xlabel('Thickness (m)')
    end
        set(gca,'FontSize',8,'FontName','Lucida Sans')

%    if III == 2
        title('Day 0')
%    end
    posy = get(gca,'Position');
    annotation('textbox',[posy(1)-.05 posy(2)+posy(4) .05 .05],'String',strs{2*(III - 1) + 2},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
 
    ylabel('Floe Size (m)')
    
    ARG = squeeze(psisave(:,:,round(end/2))+eps);
    subplot(2,4,4*(III-1) + 3)
    
    cla
    contourf([H HMSAVE(1)],R,log10(ARG),[-100 -12:1:-2],'showtext','on','textlist',[-8 -6 -4 -2])
    xlim([H(1) HMSAVE(1)])
    ylim([R(1) R(end)])
    shading interp
    grid on
    colormap jet
        set(gca,'FontSize',8,'FontName','Lucida Sans')

   % set(gca,'clim',[-12 -2])
    if III == 1
        xlabel('Thickness (m)')
    end
        title('Day 15')
    
    ARG = squeeze(psisave(:,:,end)+eps);
    subplot(2,4,4*(III-1) + 4)
    cla
    contourf([H HMSAVE(1)],R,log10(ARG),[-100 -12:1:-2],'showtext','on','textlist',[-8 -6 -4 -2])
    xlim([H(1) HMSAVE(1)])
    ylim([R(1) R(end)])
    shading interp
    grid on
    colormap jet
    set(gca,'FontSize',8,'FontName','Lucida Sans')

   % set(gca,'clim',[-12 -2])
    if III == 1
        xlabel('Thickness (m)')
    end
%    if III == 2
        title('Day 30')
%    end
    
    
     
end

%%

set(gcf,'units','inches','Windowstyle','normal','position',[0 0 8.5 4])
set(gcf,'PaperSize',[8.5 4],'Paperposition',[0 0 8.5 4])