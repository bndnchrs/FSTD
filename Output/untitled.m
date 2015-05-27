%% FD_Plot
% This contains typical routines for plotting the output of the model run

PLOT_FirstStep = 1;

if PLOT_FirstStep
    
    numtypes = do_Thermo + do_Mech + do_Swell + 1;
    XWIDTH = 1 - .1 - numtypes*.075;
    XWIDTH = XWIDTH / numtypes;
    YWIDTH = .4125;
    
    ctr = 0;
    
    if do_FD
        
        subplot('Position',[.05 + ctr*XWIDTH + ctr*.075 .05  XWIDTH YWIDTH])
        
        PLOTTER = squeeze(psisave(1,:,:)); 
        
        plot([H H_max],sum(PLOTTER,1));
        
        subplot('Position',[.05 + ctr*XWIDTH + ctr*.075 .05 + YWIDTH + .075 XWIDTH YWIDTH])
        
        
        plot(R,sum(PLOTTER,2));
        
        ctr = ctr + 1;
        
    end
    
    if do_Thermo
        
        subplot('Position',[.05 + ctr*XWIDTH + ctr*.075 .05  XWIDTH YWIDTH])
        
        plot([H H_max],sum(squeeze(psisave(1,:,:)),1));
        
        subplot('Position',[.05 + ctr*XWIDTH + ctr*.075 .05 + YWIDTH + .075 XWIDTH YWIDTH])
        ctr = ctr + 1
        
    end
    
    if do_Mech
        subplot('Position',[.05 + ctr*XWIDTH + ctr*.075 .05  XWIDTH YWIDTH])
        
        plot([H H_max],sum(squeeze(psisave(1,:,:)),1));
        
        subplot('Position',[.05 + ctr*XWIDTH + ctr*.075 .05 + YWIDTH + .075 XWIDTH YWIDTH])
        ctr = ctr + 1
        
    end
    
    if do_Swell
        
        subplot('Position',[.05 + ctr*XWIDTH + ctr*.075 .05  XWIDTH YWIDTH])
        
        plot([H H_max],sum(squeeze(psisave(1,:,:)),1));
        
        subplot('Position',[.05 + ctr*XWIDTH + ctr*.075 .05 + YWIDTH + .075 XWIDTH YWIDTH])
        ctr = ctr + 1;
        
    end
    
end