strs = {'SavedOutput/OneWeekSwell/1week_1spec_25th',...
    'SavedOutput/OneWeekSwell/1week_1spec_thin',...
    %'SavedOutput/OneWeekSwell/Sens/comp_cubatten', ...
    % 'SavedOutput/OneWeekSwell/Sens/comp_realatten'
    };

 spec = {'-','-','-','d'}
 
for i = 1:length(strs)
    loadstr = strs{i};
    load(loadstr,'Domainwidth','psisave','R','Lambda','bret_ampl','concsave', ...
        'bret_spec','wattensave','tauswellsave','fulldiffswell','time', ...
        'year','day','Rmeanarea','H','HMSAVE','Per');
    
   
    for ii = 1:length(concsave)
        SAsave(ii) = 0*concsave(ii) + integrate_FD(psisave(:,:,ii),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
    end
    
    fld = squeeze(sum(sum(abs(fulldiffswell(:,:,1:end-1)),1),2))/2;
    
    subplot(1,3,1)
    hold on
    if i~= 4
    plot(time/day,Rmeanarea)
    else
        plot(time(1:6:end)/day,Rmeanarea(1:6:end),'o','markersize',2); 
    end
    if i == 1
        title('Mean Floe Size')
        grid on
        xlabel('Time (days)')
        ylabel('m')
        set(gca,'FontName','Lucida Sans')
    end
    if i == 4
    legend({'Linear Fit','Quadratic Fit','Cubic Fit','KM (08)'})
    end
    
    xlim([0 time(end)/day])
    subplot(2,3,2)
    hold on    
    if i ~= 4
    plot(time/day,concsave + SAsave)
    else
           plot(time(1:6:end)/day,concsave(1:6:end) + SAsave(1:6:end),'o','markersize',2)
    end
    
    if i == 1
        title('Total Lateral Surface Area')
        grid on
        xlabel('Time (days)')
        ylabel('m^2')
        set(gca,'FontName','Lucida Sans')
        
    end
    xlim([0 time(end)/day])
    subplot(2,3,5)
    hold on
    if i ~= 4
    plot(time/day,wattensave(6,:)/Domainwidth,spec{i})
    else
           plot(time(1:6:end)/day,wattensave(6,1:6:end)/Domainwidth,'o','markersize',2)
    end
    if i == 1
        title('Fraction Reached')
        grid on
        xlabel('Time (days)')
        ylabel('fraction of grid cell')
        set(gca,'FontName','Lucida Sans')
    end
    
    xlim([0 time(end)/day])
    
    subplot(1,3,3)
    hold on
    if i~= 4
    plot(time/day,fld)
    else
        plot(time(1:6:end)/day,fld(1:6:end),'o','markersize',2); 
    end
    xlim([0 time(end)/day])
    if i == 1
        title('Change in FSD')
        grid on
        xlabel('Time (days)')
        ylabel('1/s')
        set(gca,'FontName','Lucida Sans')
        
    end
    
end

