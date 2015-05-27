function logcmap(ARG1,ARG2,PLOT)
%% This function pcolor plots a log-plot with positive and negative components
PLOT = PLOT + eps;

%%

extreme = 1e-2;

fudge_zero = extreme/10000;

% Log space between max and min
L = logspace(log10(fudge_zero), log10(extreme),128);  %256 entry colormap
% Now this has both sides of the spectrum
logmap = [log10(L),-fliplr(log10(L))];
    

% bins is the number in each bin locationco
PLOT = log10(PLOT+eps).*(PLOT > 0) - log10(-PLOT + eps).*(PLOT < 0); 

[bins, xbinidx] = histc(PLOT,logmap);


xsave = xbinidx; 

xbinidx = xbinidx - 128; 
xbinidx(xbinidx >=0) = xbinidx(xbinidx >=0) + 1;
% 128 cat greater than zero, 128 less than zero. Zero counts for nothing
% here. 

%%
plotter = xbinidx * (-1) + sign(xbinidx)*129; 
plotter = -plotter/128; 
pcolor(ARG1,ARG2,plotter)

[a b] = min(plotter(:)) ;
[c d] = max(plotter(:)) ;


% colorbar('YTick',[min(plotter(:))  -.5 0 .5 max(plotter(:))],'YTickLabel',{floor(logmap(max(xsave(b),1))),floor(logmap(64)),ceil(logmap(end)),ceil(logmap(192)),ceil(logmap(max(xsave(d),1)))});

end

