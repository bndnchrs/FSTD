%% FD_Plot
% This contains typical routines for plotting the output of the model run
% FLAG variables tell whether or not to plot the thing


PLOT_FirstStep_FD_FLAG = 0;
PLOT_FirstStep_PCOLOR_FLAG = 0;
% PLOT_TSTEP = 1;

if do_FD == 1
    if mod(i,1) == 0
        PLOT_TSTEP_FLAG = 0;
    else if do_FD == 0
            PLOT_TSTEP_FLAG = 1;
        else
            PLOT_TSTEP_FLAG = 0;
        end
    end
end

%%

colors = {'b','r','g','y','c','k','m','b','r','g'};

if mod(i,365*24) == -1
    
    %  FD_TOTALDIFF
    
    subplot_FD(3,2,.1,time(1:24:i)/year,concsave(1:24:i),1,1,colors{III},1);
    xlim([time(i)/year - 1; time(i)/year])
    title('Concentration')
    
    ll = smooth(drdtsave,24); 
    subplot_FD(3,2,.1,time(1:24:i)/year,ll(1:24:i),2,1,colors{III},1);
    xlim([time(i)/year - 1; time(i)/year])
    title('Mean Lateral Growth Rate')

    subplot_FD(3,2,.1,time(1:24:i)/year,HSAVE(1:24:i),3,1,colors{III},1);
    xlim([time(i)/year - 1; time(i)/year])
    
    subplot_FD(3,2,.1,time(1:24:i)/year,VMSAVE(1:24:i),1,2,colors{III},1);
    xlim([time(i)/year - 1; time(i)/year])
    title('Ice Volume')

    ll = smooth(dhdtsave,24); 
    subplot_FD(3,2,.1,time(1:24:i)/year,dhdtsave(1:24:i),2,2,colors{III},1);
    xlim([time(i)/year - 1; time(i)/year]) 
    title('Basal Growth Rate')
    
    subplot_FD(3,2,.1,time(1:24:i)/year,SAsave(1:24:i),3,2,colors{III},1);
    xlim([time(i)/year - 1; time(i)/year])
    title('Total Surface Area')
    
    PLOT_TSTEP_FLAG = 0;
else
    % PLOT_TSTEP_FLAG = 0;
end


% Plot first timestep with 1-d plots

if PLOT_FirstStep_FD_FLAG;
    
    PLOT_FirstStep_FD;
    
end

% Plot first timestep with 2-d plos
if PLOT_FirstStep_PCOLOR_FLAG;
    
    PLOT_FirstStep_PCOLOR;
    
end

% Plot single timestep with 1-d plots
if PLOT_TSTEP_FLAG
    PLOT_SINGLE_TSTEP
end

% Plot single timestep with 2-d plots
PLOT_TSTEP_PCOLOR_FLAG = 0;

if PLOT_TSTEP_PCOLOR_FLAG
    
    if isempty(H)
        plot(R,log(psi))
        drawnow
    else
        
        pcolor([H H_max],R,log(psi))
        colormap jet
        set(gca,'clim',[-12 -2]);
        shading interp
        
    end
    
    % PLOT_TSTEP_PCOLOR;
end

PLOT_HIST_WAVES = 0;

if PLOT_HIST_WAVES && do_Swell
    if mod(i,120) == 0
        [ax,p1,p2] = plotyy(Per,W_atten/Domainwidth,Per,tau_swell/day);
        p1.LineWidth = 6;
        p2.LineWidth = 6;
        ylabel(ax(1),'Attenuation Distance (fraction of domain width)','FontName','Lucida Sans','FontSize',36)
        ylabel(ax(2),'Swell Propagation Timescale (days)','FontName','Lucida Sans','FontSize',36)
        xlabel(ax(1),'Wave Period (s)','FontName','Lucida Sans','FontSize',36)
        set(ax(1),'xlim',[Per(1),Per(end)],'FontName','Lucida Sans','FontSize',36,'LineWidth',2)
        set(ax(2),'xlim',[Per(1),Per(end)],'FontName','Lucida Sans','FontSize',36,'LineWidth',2)
        box on
        grid on
    end
end

DO_PLOT_FSD_ONLY_SWELLFRAC = 0;
if DO_PLOT_FSD_ONLY_SWELLFRAC
    
    if mod(i,24) == 0
        
        PLOT_FSD_ONLY_Swell_Frac
    end
    
end
