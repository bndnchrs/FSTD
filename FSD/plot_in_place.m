function plot_in_place(TYPENUM,strout,FIGNAME,OUTNAME)

load(strout)


tnum = -1*(mod(TYPENUM,2)-1 ) + 1;

startfig = 86400*365 / dt; 

concsave = concsave(end-startfig:end);
gamsave = gamsave(end-startfig:end); 
smallfloes = smallfloes(end-startfig:end); 
nsave = nsave(:,end-startfig:end); 
T = T(end-startfig:end); 
Rmeannum = Rmeannum(end-startfig:end);
HSAVE = HSAVE(end-startfig:end);
openallsave = openallsave(:,end-startfig:end);
dhdtallsave = dhdtallsave(:,end-startfig:end);
pansave = pansave(end-startfig:end);




if TYPENUM > 2
    offset = 2; 
else
    offset = 0; 
end

FigNames = FIGNAME;

%% FIRST FIGURE PLOTTING
set(0,'CurrentFigure',FigNames{offset+1})

Pvec = [.05 + .35*(tnum - 1) + .05*(tnum - 1) ,.1,.35,.35];
subplot('Position',Pvec)

NSAVE = nsave;
sz = size(NSAVE);
for k = 1:sz(2)
    NSAVE(:,k) = NSAVE(:,k) / sum(NSAVE(:,k));
end
pcolor(R,T,(log(NSAVE).*((NSAVE > 1e-6) + eps ))')
set(gca,'YTick',[14; 14+1/6; 14+1/3; 14+1/2; 14+2/3; 14+5/6; 15],'xgrid','on')
set(gca,'YTickLabel',{'M'; 'M'; 'J'; 'S'; 'N'; 'J'; 'M'});  


shading interp
set(gca,'FontSize',24,'FontName','Palatino','ylim',[T(end)- 1; T(end)],'cLim',[-8 0])

% title('log Floe Size Distribution','FontName','Palatino','FontSize',24)
xlabel('Floe Size','FontName','Palatino','FontSize',24)
% ylabel('Time (years)','FontName','Palatino','FontSize',24)
drawnow

set(0,'CurrentFigure',FigNames{offset+1})

Pvec = [.05 + .35*(tnum - 1) + .05*(tnum - 1) ,.55,.35,.35];

%   set(0,'CurrentFigure',FigNames{fignum})
subplot('Position',Pvec)
[AX,H1,H2] = plotyy(T,[concsave;gamsave;smallfloes./concsave;],T,[Rmeannum; HSAVE]);
set(H1,'LineWidth',3)
set(H2,'LineWidth',3,'LineStyle','--')

set(AX(1),'FontSize',24,'FontName','Palatino','xlim',[T(end) - 1; T(end)],'ylim',[0 1])
set(AX(1),'XTick',[14; 14+1/6; 14+1/3; 14+1/2; 14+2/3; 14+5/6; 15])
set(AX(1),'XTickLabel',{'M'; 'M'; 'J'; 'S'; 'N'; 'J'; 'M'});  

set(AX(2),'FontSize',24,'FontName','Palatino','xlim',[T(end) - 1; T(end)])
set(AX(2),'XTick',[14; 14+1/6; 14+1/3; 14+1/2; 14+2/3; 14+5/6; 15])
set(AX(2),'XTickLabel','');  

title(OUTNAME,'FontName','Palatino','FontSize',24)

drawnow

if tnum == 2
    
    M1 = {'Ice Concentration','Ridging \Gamma','Small Floe Fraction'};
    M2 = {'Mean Floe Size','Ice Thickness'};
    
    legend(H1,M1,'Location',[.85,.2,.125,.225],'Color','White')
    legend(H2,M2,'Location',[.85,.1,.125,.1],'Color','White')
    
end
xlabel('Months (year 14)','FontName','Palatino','FontSize',24)

drawnow

%% SECOND FIGURE PLOTTING


set(0,'CurrentFigure',FigNames{offset+2})

Pvec = [.05 + .35*(tnum - 1) + .05*(tnum - 1) ,.1,.35,.35];
subplot('Position',Pvec)


plot(T,[openallsave; -pansave]','LineWidth',3)

set(gca,'FontSize',24,'FontName','Palatino','xlim',[T(end) - 1; T(end)])
set(gca,'XTick',[14; 14+1/6; 14+1/3; 14+1/2; 14+2/3; 14+5/6; 15],'xgrid','on')
set(gca,'XTickLabel',{'M'; 'M'; 'J'; 'S'; 'N'; 'J'; 'M'});  


title([OUTNAME ' Opening Components'],'FontName','Palatino','FontSize',24)
xlabel('Months (year 14)','FontName','Palatino','FontSize',24)
ylabel('1/s','FontName','Palatino','FontSize',24)
title('Opening Components','FontName','Palatino','FontSize',24)

drawnow


Pvec = [.05 + .35*(tnum - 1) + .05*(tnum - 1) ,.55,.35,.35];

set(0,'CurrentFigure',FigNames{offset+2})

subplot('Position',Pvec)
plot(T,dhdtallsave','LineWidth',3)

set(gca,'FontSize',24,'FontName','Palatino','xlim',[T(end)-1; T(end)])

title([OUTNAME ' dh/dt Components'],'FontName','Palatino','FontSize',24)
ylabel('1/s','FontName','Palatino','FontSize',24)
set(gca,'XTick',[14; 14+1/6; 14+1/3; 14+1/2; 14+2/3; 14+5/6; 15])
set(gca,'XTickLabel','','xgrid','on');  

drawnow




end