





if fig_init
    Pvec = [.05,.4,.5833, .5];
    fig_H1 = subplot('Position',Pvec)
    set(gca,'FontSize',20,'FontName','Palatino')
    hold on
    title('Ice Concentration','FontSize',24,'FontName','Palatino')
    xlabel('Time (years)','FontSize',24,'FontName','Palatino')
    
    
    
    Pvec = [.05,.1,.2667,.2];
    fig_H2 = subplot('Position',Pvec)
    set(gca,'FontSize',20,'FontName','Palatino')
    hold on
    title('Ice Thickness','FontSize',24,'FontName','Palatino')
    xlabel('Time (years)','FontSize',24,'FontName','Palatino')
    
    
    Pvec = [.3667,.1,.2667,.2];
    fig_H3 = subplot('Position',Pvec)
    set(gca,'FontSize',20,'FontName','Palatino')
    hold on
    title('Mean Floe Size','FontSize',24,'FontName','Palatino')
    xlabel('Time (years)','FontSize',24,'FontName','Palatino')
    
    
    
    Pvec = [.6833,.1,.2667,.2];
    fig_H4 = subplot('Position',Pvec)
    set(gca,'FontSize',20,'FontName','Palatino')
    hold on
    title('Thermodynamic Thickness Growth','FontSize',24,'FontName','Palatino')
    xlabel('Time (years)','FontSize',24,'FontName','Palatino')
    
    
    
    Pvec = [.6833 .4 .2667 .2];
    
    fig_H6 = subplot('Position',Pvec)
    set(gca,'FontSize',20,'FontName','Palatino')
    title('Thermodynamic Opening','FontSize',24,'FontName','Palatino')
    % xlabel('Time (years)','FontSize',24,'FontName','Palatino')
    
    
    hold on
    
    
    Pvec = [.6833 .7, .2667 .2];
    
    fig_H8 = subplot('Position',Pvec)
    set(gca,'FontSize',20,'FontName','Palatino')
    title('Surface Heat Budget','FontSize',24,'FontName','Palatino')
    % xlabel('Time (years)','FontSize',24,'FontName','Palatino')
    
    hold on
    
    
    drawnow
    
else
    
    colors = 'bgrcmyk';
    cnum = mod(j,length(colors));
    if cnum == 0
        cnum = length(colors);
    end
    
    color_plot = colors(cnum);

    % Actually Plotting
    
    isIce = (concsave ~= 0);
    isIce = isIce .* (HSAVE < 10)
    isIce(isIce == 0) = NaN;
    
    %     Pvec = [.1,.3833,.5166, .5166];
    %     subplot('Position',Pvec)
    %    hold on
    plot(fig_H1,T,concsave.*isIce,'LineWidth',8,'Color',color_plot)
    
    %     Pvec = [.1,.1,.2333 .2333];
    %     subplot('Position',Pvec)
    %     hold on
    %
    plot(fig_H2,T,HSAVE.*isIce,'LineWidth',3,'Color',color_plot)
    
    %     Pvec = [.3833 .1 .2333 .2333];
    %     subplot('Position',Pvec)
    %     hold on
    
    plot(fig_H3,T,MFS.*isIce,'LineWidth',3,'Color',color_plot)
    
    %     Pvec = [.6633 .1 .2333 .2333];
    %     subplot('Position',Pvec)
    %     hold on
    
    %   plot(fig_H4,T,squeeze(dhdtallsave(1,:)),'Color',color_plot)
    % plot(fig_H4,T,squeeze(dhdtallsave(3,:)).*isIce,'LineWidth',3,'Color',color_plot)
    plot(fig_H4,T,squeeze(dhdtallsave(2,:)).*isIce,':','LineWidth',3,'Color',color_plot)
    
    
    
    %     Pvec = [.6633 .3833 .2333 .2333];
    %     subplot('Position',Pvec)
    %     hold on
    
    %  plot(fig_H6,T,squeeze(openallsave(1,:)),'Color',color_plot)
    % plot(fig_H6,T,squeeze(openallsave(2,:)).*isIce,'LineWidth',3,'Color',color_plot)
    plot(fig_H6,T,squeeze(openallsave(3,:)).*isIce,':','LineWidth',3,'Color',color_plot)
    
    
    %     Pvec = [.6633, .6633, .2333, .2333];
    %     subplot('Position',Pvec)
    %     hold on
    
    plot(fig_H8,T,Q_surf,'LineWidth',3,'Color',color_plot);
    
    drawnow
    
end
