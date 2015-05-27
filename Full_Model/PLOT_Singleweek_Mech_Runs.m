% PLOT SingleWeek Mech Runs

Outnames = {'SavedOutput/OneWeekmech/Compressing','SavedOutput/OneWeekmech/Shear'}

for III = 1:2
    
    load(Outnames{III});
    
    
    %%
    subplot_FD(2,2,.075,time/day,concsave/concsave(1),1,III,'k',10);
    subplot_FD(2,2,.075,time/day,HSAVE/HSAVE(1),1,III,'r',10);
    subplot_FD(2,2,.075,time/day,(VSAVE + VMSAVE)/(VSAVE(1) + VMSAVE(1)),1,III,'b',10);
    subplot_FD(2,2,.075,time/day,Rmeannum/Rmeannum(1),1,III,'g',10);
    subplot_FD(2,2,.075,time/day,Rmeanarea/Rmeanarea(1),1,III,'m',10);
    
    legend({'Ice Concentration','Mean Ice Thickness','Ice Volume','Mean Floe Size','Modal Floe Size'});

    xlim([time(1)/day time(end)/day])
    if III == 1
        xlabel('Time (days)')
        title('Convergence Only')
    end
    if III == 2
        title('Shear Only')
    end
    ylabel('Multiple of Initial')
    
    
    ARG = squeeze(psisave(:,:,1));
    subplot_FD(6,2,.075,[H H_max],ARG,4,III,R,'',1)
    cla
    contourf([H H_max],R,log10(ARG),[-12:1:-2])
    xlim([H(1) H_max])
    ylim([R(1) R(end)])
    shading interp
    colormap jet
    set(gca,'clim',[-12 -2])
    if III == 1
        xlabel('Thickness (m)')
    end
    
    if III == 2
        title('Day 0')
    end
    
    ylabel('Floe Size (m)')
    
    ARG = squeeze(psisave(:,:,round(end/2)));
    subplot_FD(6,2,.075,[H H_max],ARG,5,III,R,'',1)
    cla
    contourf([H H_max],R,log10(ARG),[-15:1:-2])
    xlim([H(1) H_max])
    ylim([R(1) R(end)])
    shading interp
    colormap jet
    set(gca,'clim',[-12 -2])
    if III == 1
        xlabel('Thickness (m)')
    end
    if III == 2
        title('Day 7')
    end
    
    ARG = squeeze(psisave(:,:,end));
    subplot_FD(6,2,.075,[H H_max],ARG,6,III,R,'',1)
    cla
    contourf([H H_max],R,log10(ARG),[-12:1:-2])
    xlim([H(1) H_max])
    ylim([R(1) R(end)])
    shading interp
    colormap jet
    set(gca,'clim',[-12 -2])
    if III == 1
        xlabel('Thickness (m)')
    end
    if III == 2
        title('Day 14')
    end
    
    
end