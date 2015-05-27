%% PLOT_FirstStep_FD; 
% This code plots the first timestep of the model run in terms of its
% marginal distributions

    close
    figure
    
    numtypes = do_Thermo + do_Mech + do_Swell + 1;
    XWIDTH = 1 - .1 - numtypes*.075;
    XWIDTH = XWIDTH / numtypes;
    YWIDTH = .4125;
    
    
    labels = {'In','Out','Net'};
    
    ctr = 1;
    
    if do_FD
        
        subplot_FD(numtypes,2,.075,[H H_max],sum(psisave(:,:,1),1),ctr,1,'b',6,0)
        xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',24)
        ylabel('Fractional Area','FontName','Palatino','FontSize',24)
        title('Initial Ice Thickness Dist.','FontName','Palatino','FontSize',36)
        subplot_FD(numtypes,2,.075,R,sum(psisave(:,:,1),2),ctr,2,'b',6,0)
        xlabel('Floe Size (m)','FontName','Palatino','FontSize',24)
        ylabel('Fractional Area','FontName','Palatino','FontSize',24)
        title('Initial Floe Size Dist.','FontName','Palatino','FontSize',36)
        
        
        ctr = ctr + 1;
        
    end
    
    if do_Thermo
        
        
        subplot_FD(numtypes,2,.075,[H H_max],dt*sum(dtmin,1),ctr,1,'r',6,0)
        subplot_FD(numtypes,2,.075,[H H_max],dt*sum(dtplus,1),ctr,1,'g',6,0)
        subplot_FD(numtypes,2,.075,[H H_max],dt*sum((dtmin + dtplus),1),ctr,1,'k',6,0)
        xlim([H(2) H_max])
        xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',24)
        ylabel('Fractional Area Change','FontName','Palatino','FontSize',24)
        
        
        subplot_FD(numtypes,2,.075,R,dt*sum(dtmin,2),ctr,2,'r',6,0)
        subplot_FD(numtypes,2,.075,R,dt*sum(dtplus,2),ctr,2,'g',6,0)
        subplot_FD(numtypes,2,.075,R,dt*sum(dtmin + dtplus,2),ctr,2,'k',6,0)
        xlim([R(2) max(R)])
        xlabel('Floe Size (m)','FontName','Palatino','FontSize',24)
        title('Thermodynamic Change','FontName','Palatino','FontSize',36)
        ylabel('Fractional Area Change','FontName','Palatino','FontSize',24)
        
        
        legend(labels,'FontSize',36','FontName','Palatino')
        
        ctr = ctr + 1;
        
    end
    
    if do_Mech
        
        subplot_FD(numtypes,2,.075,[H H_max],sum(dt*In,1),ctr,1,'g')
        subplot_FD(numtypes,2,.075,[H H_max],-sum(dt*Out,1),ctr,1,'r')
        subplot_FD(numtypes,2,.075,[H H_max],sum(dt*diff_mech,1),ctr,1,'k')
        xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',24)
        ylabel('Fractional Area Change','FontName','Palatino','FontSize',24)
        
        
        subplot_FD(numtypes,2,.075,R,sum(dt*In,2),ctr,2,'g')
        subplot_FD(numtypes,2,.075,R,-sum(dt*Out,2),ctr,2,'r')
        subplot_FD(numtypes,2,.075,R,sum(dt*diff_mech,2),ctr,2,'k')
        xlabel('Floe Size (m)','FontName','Palatino','FontSize',24)
        title('Mechanical Change','FontName','Palatino','FontSize',36)
        ylabel('Fractional Area Change','FontName','Palatino','FontSize',24)
        legend(labels,'FontSize',36','FontName','Palatino')
        
        
        ctr = ctr + 1;
        
    end
    
    if do_Swell
        
        subplot_FD(numtypes,2,.075,[H H_max],sum(dt*In_Swell,1),ctr,1,'g')
        subplot_FD(numtypes,2,.075,[H H_max],sum(dt*Out_Swell,1),ctr,1,'r')
        subplot_FD(numtypes,2,.075,[H H_max],sum(diff_swell*dt,1),ctr,1,'k')
        xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',24)
        ylabel('Fractional Area Change','FontName','Palatino','FontSize',24)
        
        subplot_FD(numtypes,2,.075,R,sum(dt*In_Swell,2),ctr,2,'g')
        subplot_FD(numtypes,2,.075,R,sum(dt*Out_Swell,2),ctr,2,'r')
        subplot_FD(numtypes,2,.075,R,sum(diff_swell*dt,2),ctr,2,'k')
        xlabel('Floe Size (m)','FontName','Palatino','FontSize',24)
        title('Swell Fracture Change','FontName','Palatino','FontSize',36)
        ylabel('Fractional Area Change','FontName','Palatino','FontSize',24)
        legend(labels,'FontSize',36','FontName','Palatino')
        
        
        ctr = ctr + 1;
    end