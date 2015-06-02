% little plotting routine
loadnames = {'../FSTD-OUTPUT/Storms_Tmelt_1thick1m',...
    '../FSTD-OUTPUT/NoStorms_Tmelt_1thick1m'};

%%
savename = 'Comp_1thick1m_adv'; 

close all
figure
set(gcf,'windowstyle','normal','units','inches', ...
    'papersize',[8.5 6],'paperposition',[0 0 8.5 6])

titles = {'Concentration','Ice Volume','Mean of FSTD','Ocean Temperature'};
yax = {'% of Initial','% of Initial','m','^\circ C'};

for i = 1:4
    plots{i} = subplot(2,2,i); 
    hold on
    grid on
    box on
    set(gca,'FontName','Lucida Sans','FontSize',10); 
    xlim([0 300])
    title(titles{i})
    ylabel(yax{i})
    xlabel('Time (days)')

end

%%

for i = 1:2
    
load(loadnames{i},'DIAG')

plot(plots{1},FSTD.time/86400,DIAG.conc/DIAG.conc(1));

plot(plots{2},FSTD.time/86400,DIAG.V_tot/DIAG.V_tot(1));
plot(plots{3},FSTD.time/86400,DIAG.Rmeanarea);
plot(plots{4},FSTD.time/86400,DIAG.OceanT);

end

legend({'Storms','No Storms'},'Position',[0.4544    0.4965    0.1248    0.0244],'Orientation','horizontal')

saveas(gcf,['Images/' savename '.pdf'])
