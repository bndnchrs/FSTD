%% CONTOUR_MULTIPLE_RUNS_JOINT


Outnamer =  {'SavedOutput/OneMonthmech/Sens/1f_Noinc_dr2', ...
    'SavedOutput/OneMonthmech/Sens/NoincR_dr4', ...
    'SavedOutput/OneMonthmech/Sens/incR_dr2', ...
    'SavedOutput/OneMonthmech/Sens/incR_dr4', ...
    'SavedOutput/OneMonthmech/Sens/incboth_dr2', ...
    'SavedOutput/OneMonthmech/Sens/incboth_dr4' ...
    };

Titles = {'Increase None dr=2','Increase none dr=4','Increase r dr = 2','Increase r dr = 4','Increase both dr = 2','Increase both dr = 4 '};


%%
for III = 1:length(Outnamer)
    
    out = [Outnamer{III} '_Conv'];
    
    load(out,'psisave','year','time','HMSAVE','H','R','concsave','TotVol','Volex','HSAVE');
    
    PS{III} = psisave;
    t(III) = length(time);
    
    HS{III} = H; 
    RS{III} = R; 
    
    plotter = [concsave; TotVol+Volex; HSAVE];
    
    
    sz = size(plotter); 
    
    PL{III} = plotter; 
%     for k = 1:sz(1)
%     
%         subplot(2,sz(1),k);
%         hold on
%         plot(time/year,plotter(k,:))
%     
%         xlabel('Time (years)')
%         
%     end
    
end

%%


for ii = 1:12:360

        
    
    for III = 1:length(Outnamer)
        
        sploty = mod(III,2);
        splotx = III - sploty*3;
        
        subplot(3,2,III);
        
        contourf([HS{III} HMSAVE(1)],RS{III},log10(PS{III}(:,:,ii)+eps),[-100 -10:1:-1],'k','showtext','on','textlist',[-8 -6 -4 -2]);
        xlabel('Ice Thickness');
        ylabel('Floe Size');
        grid on
        colormap jet
        caxis([-10 -1])
        
        title(Titles{III})
        
        
    end
    
    drawnow
    
    
end
