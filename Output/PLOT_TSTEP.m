%% PLOT_TSTEP
    % This code plots one timestep in terms of the marginal distributions
    clf
    
    numtypes = 2;
    ispcolor = 0;
    
    subplot_FD(numtypes,2,.075,[H H_max],sum(psisave(:,:,i),1),1,1)
    subplot_FD(numtypes,2,.075,[H H_max],sum(psisave(:,:,1),1),1,1,'--k',3)
    xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',18)
    ylabel('Fractional Area','FontName','Palatino','FontSize',18)
    
    title('Ice Thickness Distribution','FontName','Palatino','FontSize',18)
    ylim([0 .075])
    xlim([0 H_max])
    
    labels = {'Thickness Distribution','Initial Thickness Distribution'};
    legend(labels,'FontSize',36','FontName','Palatino')
    
    subplot_FD(numtypes,2,.075,R,sum(psisave(:,:,i),2),1,2)
    subplot_FD(numtypes,2,.075,R,sum(psisave(:,:,1),2),1,2,'--k',3)
    xlabel('Floe Size (m)','FontName','Palatino','FontSize',18)
    ylabel('Fractional Area','FontName','Palatino','FontSize',18)
    title('Floe Size Distribution','FontName','Palatino','FontSize',18)
    ylim([0 .075])
    
    if length(R)> 1
        xlim([min(R) max(R)])
    end
    labels = {'Floe Size Distribution','Initial Floe Size Distribution'};
    legend(labels,'FontSize',36','FontName','Palatino')
    
    
    
    subplot_FD(numtypes,2,.075,time(1:i)/month,concsave(1:i),2,1)
    subplot_FD(numtypes,2,.075,time(1:i)/month,HMSAVE(1:i)/HMSAVE(1),2,1,'r')
    subplot_FD(numtypes,2,.075,time(1:i)/month,VSAVE(1:i)/VSAVE(1),2,1,'y')
    subplot_FD(numtypes,2,.075,time(1:i)/month,Q_surf(1:i)/300,2,1,'y')
    xlabel('Time (months)','FontName','Palatino','FontSize',18)
    % ylabel('Mean Floe Thickness','FontName','Palatino','FontSize',18)
    title('Mean Thickness','FontName','Palatino','FontSize',18)
    %ylim([.5*HSAVE(1) 2*HSAVE(1)])
    xlim([0 time(i)/month+1])
    ylim([0 5])
    
    if do_Mech == 1
        
        subplot_FD(numtypes,2,.075,time(1:i)/month,squeeze(sum(sum(abs(fulldiffmech(:,:,1:i)),2),1)),2,2,'r')
        
    end
    
    
    if do_Thermo == 1
        subplot_FD(numtypes,2,.075,time(1:24:i)/month,squeeze(sum(sum(abs(fulldiffthermo(:,:,1:24:i)),2),1)),2,2,'g')
    end
    %  subplot_FD(numtypes,2,.075,time(1:i)/month,squeeze(sum(sum(abs(fulldiffswell(:,:,1:i)),2),1)),2,2,'b')
    xlabel('Time (months)','FontName','Palatino','FontSize',18)
    ylabel('Mean Floe Size','FontName','Palatino','FontSize',18)
    title('Mean Floe Size','FontName','Palatino','FontSize',18)
    
    xlim([0 time(i)/month+1])
    
    drawnow
    
