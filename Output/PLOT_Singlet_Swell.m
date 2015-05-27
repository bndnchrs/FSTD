%% PLOT_Singlet_Swell

%% Calculate Some Things

for ii = 1:length(concsave)
    
    SAsave(ii) = concsave(ii) + integrate_FD(psisave(:,:,ii),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
    SAin(ii) = concsave(ii) + integrate_FD(psisave(:,:,ii).*(fulldiffsave(:,:,ii) > 0),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
    SAout(ii) = concsave(ii) + integrate_FD(psisave(:,:,ii).*(fulldiffsave(:,:,ii) < 0),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
    
end


%%
if i == 1
    
    %figure('units','inches','Position',[0 0 36 24])
    
    %% Plot the FSD and Wave Spectrum
    % At the top
    
    %subplot('Position', [0.1300    0.7093    0.4942    0.2091]);
    
    AX0 = subplot(3,1,1)
    plot(R,FSD(:,1)/sum(FSD(:,1)));
    hold(AX0,'on')
    h0 = plot(R,FSD(:,1)/sum(FSD(:,1)),'k');
    h21 = plot(R,FSD(:,1)/sum(FSD(:,1)),'g');
    h22 = plot(R,FSD(:,1)/sum(FSD(:,1)),'r');
    
    xlabel(AX0,'Size (m)')
    % plot(AX0(2),R,cumsum(bret_spec/sum(bret_spec)));
    %set(AX0,'YScale','linear','LineWidth',2,'FontSize',24)
    set(AX0,'Ylim',[0 .2])
    set(AX0,'YTick',[0 .05 .1 .15 .2])
    % grid on
    set(AX0,'Xlim',[0 R(end)])
    title(AX0,'Floe Size Distribution')
    grid(AX0,'on')
    legend({'FSD (initial)','FSD (current)','Incoming FSD','Outgoing FSD'});
    
    
    %% Three middle plots showing a single variable each
    AX(2) = subplot(3,3,4);
   % AX(3) = subplot(3,3,5);
    AX(4) = subplot(3,3,6);
    
    
    
    hold(AX(2),'on');
    set(AX(2),'LineWidth',1,'xlim',[0 time(end)/day])
    title(AX(2),'Mean Floe Size')
    grid(AX(2),'on')
    xlabel(AX(2),'Time (days)')
    p3 = plot(AX(2),time/day,Rmeanarea,'k','LineWidth',1);
    p32 = plot(AX(2),time/day,Rmean_in,'g','LineWidth',1);
    p33 = plot(AX(2),time/day,Rmean_out,'r','LineWidth',1);
    p34 = plot(AX(2),time/day,Rmeannum,'-k','LineWidth',1);
    
    legend(AX(2),{'Total','Incoming Floes','Outgoing Floes','by number'})

    subplot(3,3,5)

    [p1,~,~] = plotyy(time(1:length(SAsave))/day,SAsave/SAsave(1),time/day,number_of_floes/number_of_floes(1));
    
    hold(p1(1),'on');
    hold(p1(2),'on');
    set(p1(1),'LineWidth',1,'xlim',[0 time(end)/day])
    set(p1(2),'LineWidth',1,'xlim',[0 time(end)/day])
    title(p1(1),'Floe Surface Area and Floe Number')
    grid(p1(1),'on')
    xlabel(p1(1),'Time (days)')
    ylabel(p1(1),'Surface Area / Initial')
    ylabel(p1(2),'Floe No. / Initial')
   % plot(AX(3),time(1:length(SAin))/day,SAin,'k','LineWidth',1);
   % plot(AX(3),time(1:length(SAout))/day,SAout,'k','LineWidth',1);


    hold(AX(4),'on');
    set(AX(4),'LineWidth',1,'xlim',[0 time(end)/day])
    title(AX(4),'Total Area Change per Timestep')
    grid(AX(4),'on')
    xlabel(AX(4),'Time (days)')
    fld = squeeze(sum(sum(abs(fulldiffswell(:,:,2:end)),1),2))/2;
    p2 = plot(AX(4),time(1:length(fld))/day,fld,'k','LineWidth',1);
    
    %% Now a single plot showing attenuation fraction and the like
    
    subplot(3,3,7);
    
    [BX0,H0,H2] = plotyy(Per,wattensave(:,1)/1e4,Per,tauswellsave(:,1)/3600);
    
    hold(BX0(1),'on')
    xlabel(BX0(1),'Period (s)')
    
    set(BX0(1),'YScale','linear','LineWidth',1)
    set(BX0(1),'YTick',[0 .5 1])
    set(H0,'LineStyle','--')
    set(BX0(2),'YScale','linear','LineWidth',1)
    set(BX0(1),'Ylim',[0 1])
    set(BX0(2),'Ylim',[0 6])
    set(BX0(2),'YTick',[0 3 6])
    ylabel(BX0(2),'# of timesteps')
    set(BX0(1),'Xlim',[0 Per(end)],'YMinorTick','off')
    grid on
    title(BX0(1),'Attenuation Fraction (% of Grid')
    grid(BX0(1),'on')
    legend({'Atten. Frac.','Wave Pen. Timescale (Initial)','Wave Pen. Timescale (Current)'})
    
    
    %% Plot the relative change over time
    
    A2 = subplot(3,3,8);
    
    %h5 = plot(R,in_FSD(:,i));
    %set(A2,'Ylim',[-5e-3 5e-3]);
    set(A2,'Xlim',[0 time(end)/day]);
    plot(A2,time/day,wattensave(3,:)/Domainwidth); 
    grid on
    hold(A2,'on')
    xlabel(A2,'Time (days)')
    ylabel(A2,'Fraction of Grid')
    title(A2,'Peak Period Pen. Frac.')
    
    
    
    A3 = subplot(3,3,9);
    
    
    plot(Per,bret_spec/max(bret_spec))
    set(A3,'Ylim',[0 1])
    
    grid on
    hold(A3,'on')
    xlabel(A3,'Period (s)')
    ylabel(A3,'Energy (normalized)')
    title(A3,'Wave Spectrum')
    
    
    clear H0
    
elseif i > 1
    
    %%
    % This plots with the thermo on the right axis
    if exist('h0','var')
        delete(h0)
    end
    if exist('h21','var')
        delete(h21);
    end
    if exist('h22','var')
        delete(h22);
    end
    
    if exist('h2','var')
        delete(h2)
    end
    if exist('h3','var')
        
        delete(h3)
    end
    if exist('h32','var')
        
        delete(h32)
    end
    if exist('h33','var')
        
        delete(h33)
        delete(h34)
    end
    if exist('h5','var')
        delete(h5)
    end
    if exist('g1','var')
        
        delete(g1)
  %      delete(g12)
   %     delete(g13)
    end
    
    if exist('g2','var')
        
        delete(g2)
    end
    
    if exist('HH0','var')
        
        delete(HH0)
    end
    
%     if exist('p3','var')
%         delete(p3);
%     end
    
    if exist('ss','var')
        delete(ss);
    end
    
    ff = FSD(:,i)/sum(FSD(:,i));
    %   dd = ff.*diff_swell(:,i)./(ff * sum(abs(diff_swell(:,i))));
    %   dd1 = ff.*diff_swell(:,i)./(ff * sum(abs(diff_swell(:,i))));
    
    % dd = dd - min(dd1);
    
    h0 = plot(AX0,R,ff,'k','LineWidth',1);
    h21 = plot(AX0,R,in_FSD(:,i)*max(FSD(:,i)),'g','LineWidth',1);
    h22 = plot(AX0,R,out_FSD(:,i)*max(FSD(:,i)),'r','LineWidth',1);
    if i == 2
    legend(AX0,{'FSD (initial)','FSD (current)','Incoming FSD','Outgoing FSD'});
    end
    
    h3 = scatter(AX(2),time(i)/day,Rmeanarea(i),300,'k','filled');
    h32 = scatter(AX(2),time(i)/day,Rmean_in(i),300,'g','filled');
    h33 = scatter(AX(2),time(i)/day,Rmean_out(i),300,'r','filled');
    h34 = scatter(AX(2),time(i)/day,Rmeannum(i),300,'m','filled');

    g1 = scatter(p1(1),time(i)/day,SAsave(i)/SAsave(1),300,'k','filled');
   % g12 = scatter(AX(3),time(i)/day,SAin(i),300,'g','filled');
   % g13 = scatter(AX(3),time(i)/day,SAout(i),300,'b','filled');
    
    g2 = scatter(AX(4),time(i)/day,squeeze(sum(sum(abs(fulldiffswell(:,:,i-1)),1),2))/2,300,'k','filled');
    
    
    HH0 = plot(BX0(1),Per,wattensave(:,i)/1e4,'k','LineWidth',1);
   
    ss = scatter(A2,time(i)/day,wattensave(3,i)/Domainwidth,300,'k','filled');
   
    
    h2 = scatter(p1(2),time(i)/day,number_of_floes(i)/number_of_floes(1),300,'k','filled');


    %   p1 = plot(AX(3),time(1:i)/day,SAsave(1:i),'k','LineWidth',1);
    %   p2 = plot(AX(4),time(1:i)/day,squeeze(sum(sum(abs(fulldiffswell(:,:,2:i+1)),1),2))/2,'k','LineWidth',1);
    
    
    drawnow
   

end

