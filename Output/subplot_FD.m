function subplot_FD(numx,numy,spacing,ARG,PLOTTER,ctx,cty,optarg1,optarg2,ispcolor)
% optarg1 should be either the linespec (if ispcolor = 0) or the second
% argument for the pcolor plotting
% optarg2 should be the linewidth of a plot or is ignored if pcolor is on

if nargin < 8
    spec = '';
    ispcolor = 0;
    linewidth = 6;
else if nargin < 9
        spec = optarg1;
        linewidth = 6;
        ispcolor = 0;
    else if nargin < 10
            spec = optarg1;
            linewidth = optarg2;
            ispcolor = 0;
        else
            spec = optarg1;
            linewidth = optarg2;
        end
    end
end

XWIDTH = (1 - .15 - spacing*(numx-1))/numx;
YWIDTH = (1 - .2 - spacing*(numy-1))/numy;


POSVEC = [.05 + (ctx-1)*(XWIDTH+spacing) .1 + (cty-1)*(YWIDTH+spacing) XWIDTH YWIDTH];

subplot('Position',POSVEC,'FontName','Lucida Sans','FontSize',24);
hold on

if ispcolor
    
    if min(PLOTTER(:)) < 0
        logcmap(ARG,optarg1,PLOTTER); 
    else
        pcolor(ARG,optarg1,log10(PLOTTER+eps)); 
    end
    
    
else
    
    plot(ARG,PLOTTER,spec,'LineWidth',linewidth)
    
end

box on
grid on

set(gca,'linewidth',2)
set(gca,'FontName','Lucida Sans','FontSize',28)
end