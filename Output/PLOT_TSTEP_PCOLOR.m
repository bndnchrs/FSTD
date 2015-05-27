%% PLOT_TSTEP_PCOLOR
% This code plots a single timestep of the model with pcolor plots
% For psi
lims1 = [-10 -1];
% for diff
lims2 = [-10 10];

numtypes = do_Thermo + do_Mech + do_Swell + 1;
XWIDTH = 1 - .1 - numtypes*.075;
XWIDTH = XWIDTH / numtypes;
YWIDTH = .4125;


labels = {'In','Out','Net'};

ctr = 1;

ann = {'(a)','(b)','(c)','(d)'};

if do_FD
    
    %%
    
    ARG = log10(psisave(:,:,i));
    
    subplot(1,numtypes,ctr)
    pcolor(meshH,meshR,ARG)
    
    xlim([H(1) H_max])
    ylim([R(1) R(end)])
    xlabel('Floe Thickness (m)','FontName','Lucida Sans','FontSize',8)
    ylabel('Floe Size (m)','FontName','Lucida Sans','FontSize',8)
    title('Initial Distribution','FontName','Lucida Sans','FontSize',8)
    
    hold on
    
    cRange = caxis;
    
    
    contour(meshH,meshR,log10(squeeze(psisave(:,:,1))+eps),linspace(-10,-1,10),'k')
    caxis(cRange);
    xlim([H(1) H_max])
    grid on
    set(gca,'layer','top')
    p = get(gca,'Position');
    annotation('textbox',[p(1)-.04 p(2)+p(4) .05 .05],'String',ann{ctr},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
    
    ctr = ctr + 1;
    caxis(lims1)
    
    colormap jet
    freezeColors;
    set(gca,'LineWidth',1,'FontSize',8)
    
    shading interp
    
    
    
    
    
end
%%
if do_Thermo
    
    colormap(darkb2r(-1,1))
    
    % Plot the log difference due to thermodynamics!
    ARG = dt*fulldiffthermo(:,:,i);
    subplot(1,numtypes,ctr)
    
    logcmap(meshH,meshR,ARG);
    
    
    
    % Keep the same range of colors
    cRange = [-1 1];
    
    % Want to plot this along with the actual floe size distribution
    hold on
    contour(meshH,meshR,log10(squeeze(psisave(:,:,i))+eps),linspace(-10,-1,10),'k')
    
    
    caxis(cRange);
    
    % fix axis limits and labels
    xlim([H(1) H_max])
    ylim([R(1) R(end)])
    xlabel('Floe Thickness (m)','FontName','Lucida Sans','FontSize',8)
    ylabel('Floe Size (m)','FontName','Lucida Sans','FontSize',8)
    title('Thermodynamic Change','FontName','Lucida Sans','FontSize',8)
    
    
    grid on
    set(gca,'layer','top')
    
    p = get(gca,'Position');
    annotation('textbox',[p(1)-.04 p(2)+p(4) .05 .05],'String',ann{ctr},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
    
    ctr = ctr + 1;
    set(gca,'LineWidth',1,'FontSize',8)
    
    shading interp
    
    
end

%%
if do_Mech
    
    ARG = dt*fulldiffmech(:,:,i);
    
    
    subplot(1,numtypes,ctr)
    logcmap(meshH,meshR,ARG);
    colormap(darkb2r(-1,1))
    xlabel('Floe Thickness (m)','FontName','Lucida Sans','FontSize',8)
    ylabel('Floe Size (m)','FontName','Lucida Sans','FontSize',8)
    hold on
    
    freezeColors
    
    cRange = [-1 1];
    
    %%
    
    contour(meshH,meshR,log10(squeeze(psisave(:,:,i))+eps),linspace(-10,-1,10),'k')
    caxis(cRange);
    
    xlim([H(1) H_max])
    
    
    %%
    if length(R) > 1
        ylim([R(1) R(end)])
    end
    
    grid on
    set(gca,'layer','top')
    xlabel('Floe Thickness (m)','FontName','Lucida Sans','FontSize',8)
    ylabel('Floe Size (m)','FontName','Lucida Sans','FontSize',8)
    title('Mechanical Change','FontName','Lucida Sans','FontSize',8)
    p = get(gca,'Position');
    annotation('textbox',[p(1)-.04 p(2)+p(4) .05 .05],'String',ann{ctr},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
    
    ctr = ctr + 1;
    set(gca,'LineWidth',1,'FontSize',8)
    
    shading interp
    
end

%%
if do_Swell
    
    %% Swell Change
    ARG = dt*fulldiffswell(:,:,i);
    
    
    subplot(1,numtypes,ctr)
    logcmap(meshH,meshR,ARG);
    
    colormap(darkb2r(-2,2))
    xlabel('Floe Thickness (m)','FontName','Lucida Sans','FontSize',8)
    ylabel('Floe Size (m)','FontName','Lucida Sans','FontSize',8)
    hold on
    
    freezeColors
    
    cRange = [-1 1];
    
    %%
    
    contour(meshH,meshR,log10(squeeze(psisave(:,:,i))+eps),linspace(-10,-1,10),'k')
    caxis(cRange);
    
    xlim([H(1) H_max])
    
    
    %%
    if length(R) > 1
        ylim([R(1) R(end)])
    end
    
    grid on
    set(gca,'layer','top')
    xlabel('Floe Thickness (m)','FontName','Lucida Sans','FontSize',8)
    ylabel('Floe Size (m)','FontName','Lucida Sans','FontSize',8)
    title('Fracture Change','FontName','Lucida Sans','FontSize',8)
    p = get(gca,'Position');
    annotation('textbox',[p(1)-.04 p(2)+p(4) .05 .05],'String',ann{ctr},'LineStyle','none','FontName','Lucida Sans','FontSize',8)
    
    ctr = ctr + 1;
    set(gca,'LineWidth',1,'FontSize',8)
    
    shading interp
    
end

drawnow
