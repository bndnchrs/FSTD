%% PLOT_FirstStep_PCOLOR
   % This code plots the first step in a pcolor plot
   
    defCMAP = [-1e-5 1e-5]
    
    close
    figure
    
    numtypes = do_Thermo + do_Mech + do_Swell + 1;
    XWIDTH = 1 - .1 - numtypes*.075;
    XWIDTH = XWIDTH / numtypes;
    YWIDTH = .4125;
    
    
    labels = {'In','Out','Net'};
    
    ctr = 1;
    
    if do_FD
        
        ARG = squeeze(psisave(:,:,1));
        
        subplot_FD(numtypes,1,.075,[H H_max],ARG,ctr,1,R,'',1)
        xlim([H(1) H_max])
        ylim([R(1) R(end)])
        xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',36)
        ylabel('Floe Size','FontName','Palatino','FontSize',36)
        title('Initial Distribution','FontName','Palatino','FontSize',36)
        
        hold on
        
        contour(meshH,meshR,squeeze(psisave(:,:,1)),5,'k')
        grid on
        set(gca,'layer','top')
        
        ctr = ctr + 1;
        
        % This step saves the colormap for this axis
        lims = [0 max(ARG(:))]
        
        caxis(lims)
        colormap(darkb2r(-max(ARG(:)),lims(2)))
        freezeColors;
        set(gca,'LineWidth',2)
        
    end
    
    if do_Thermo
        
        
        ARG = diff_thermo;
        
        subplot_FD(numtypes,1,.05,[H H_max],dt*ARG,ctr,1,R,'',1)
        hold on
        cRange = caxis;
        contour(meshH,meshR,squeeze(psisave(:,:,1)),5,'k')
        caxis(cRange);
        xlim([H(1) H_max])
        ylim([R(1) R(end)])
        xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',36)
        ylabel('Floe Size','FontName','Palatino','FontSize',36)
        title('Thermodynamic Change','FontName','Palatino','FontSize',36)
        grid on
        set(gca,'layer','top')
        
        caxis(defCMAP)
        colormap(darkb2r(min(defCMAP),max(defCMAP)))
        
        
        ctr = ctr + 1;
        set(gca,'LineWidth',2)
        
    end
    
    if do_Mech
        
        subplot_FD(numtypes,1,.05,[H H_max],dt*diff_mech,ctr,1,R,'',1)
        
        xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',18)
        ylabel('Floe Size','FontName','Palatino','FontSize',18)
        hold on
        cRange = caxis;
        contour(meshH,meshR,squeeze(psisave(:,:,1)),5,'k')
        caxis(cRange);
        xlim([H(1) H_max])
        
        if length(R) > 1
            ylim([R(1) R(end)])
        end
        
        grid on
        set(gca,'layer','top')
        xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',36)
        ylabel('Floe Size','FontName','Palatino','FontSize',36)
        title('Mechanical Change','FontName','Palatino','FontSize',36)
        
        caxis(defCMAP)
        colormap(darkb2r(min(defCMAP),max(defCMAP)))
        
        ctr = ctr + 1;
        set(gca,'LineWidth',2)
    end
    
    if do_Swell
        
        subplot_FD(numtypes,1,.05,[H H_max],dt*diff_swell,ctr,1,R,'',1)
        
        hold on
        cRange = caxis;
        contour(meshH,meshR,squeeze(psisave(:,:,1)),5,'k')
        caxis(cRange);
        xlim([H(1) H_max])
        
        if length(R) > 1
            ylim([R(1) R(end)])
        end
        
        grid on
        set(gca,'layer','top')
        xlabel('Floe Thickness (m)','FontName','Palatino','FontSize',36)
        ylabel('Floe Size','FontName','Palatino','FontSize',36)
        title('Swell Fracture Change','FontName','Palatino','FontSize',36)
        
        caxis(defCMAP)
        colormap(darkb2r(min(defCMAP),max(defCMAP)))
        
        ctr = ctr + 1;
        set(gca,'LineWidth',2)
    end
    