colors = {'b','r','g','y','c','k','m','b','r','g'};
xx =  [0.4417    0.5250    0.6083    0.6916    0.7749    0.8582    0.9415    1.0248    1.1081    1.1914    1.2747    1.3580    1.4413]
%xx = xx + xx(2) - xx(1); 

yy = {'F','M','A','J','J','A','S','O','N','D','J','F'};

rpvar = [.1 .25 .5 1 2 5 10 20];

for i = 1:length(rpvar)
    p = num2str(rpvar(i)); 
    p(p=='.') = 'p';
    
    filenames{i} = ['SavedOutput/AnnDiurn/Sens/RP' p]; 

end

figure; 

for III = 1:length(filenames)
    subplot(1,2,1)
    load(filenames{III},'year','time','pansave')
    ll = 86400*smooth(pansave,24);
    if rpvar(III) > .5
        liner = '--'
    else
        liner = '';
    end
    plot(time(1:24:end)/year,ll(1:24:end),liner)
    hold on
    xlim([xx(1) xx(end)])
    set(gca,'XTick',xx,'XTickLabel',yy)
    title('Pancake Area Added')
    grid on
    ylabel('1/day')
    
    subplot(1,2,2)
        load(filenames{III},'year','time','Alsave')
    ll = smooth(Alsave,24);
    if rpvar(III) > .5
        liner = '--'
    else
        liner = '';
    end
    plot(time(1:24:end)/year,ll(1:24:end),liner)
    hold on
    xlim([xx(1) xx(end)])
    set(gca,'XTick',xx,'XTickLabel',yy)
    title('Pancake Area Added')
    grid on
    ylabel('1/day')
end

legend({'.1m','.25 m','.5 m','1 m','2 m','5 m','20 m'})

%%
for III = 1:length(filenames)
    
    load(filenames{III},'concsave','time','year','drdtsave','dhdtsave','SAsave','HSAVE','VMSAVE','pansave')

    %  FD_TOTALDIFF
    ll = smooth(concsave,24);
    subplot(2,3,1)
    hold on
    plot(time(1:24:end)/year,ll(1:24:end))
    xlim([xx(1) xx(end)])
    set(gca,'XTick',xx,'XTickLabel',yy)
    title('Concentration')
    grid on
    ylabel('m^2/m^2')
    
    ll = smooth(drdtsave,24); 
    subplot(2,3,2)
    hold on
    plot(time(1:24:end)/year,ll(1:24:end)*86400*100)
    xlim([xx(1) xx(end)])
    set(gca,'XTick',xx,'XTickLabel',yy)
    title('24-hr mean lateral growth rate')
    ylabel('cm/day')
    grid on

    ll = smooth(dhdtsave,24); 
    subplot(2,3,3)
    hold on
    plot(time(1:24:end)/year,ll(1:24:end)*86400*100)
    xlim([xx(1) xx(end)])
    set(gca,'XTick',xx,'XTickLabel',yy)
    title('24-hr mean basal growth rate')
    ylabel('cm/day')
    grid on
    
    ll = smooth(HSAVE,24);
    subplot(2,3,4)
    hold on
    plot(time(1:24:end)/year,ll(1:24:end))
    xlim([xx(1) xx(end)])
    set(gca,'XTick',xx,'XTickLabel',yy)
    title('Ice Thickness')
    ylabel('m')
    grid on
    
    ll = 86400*smooth(pansave,24);
    % ll = smooth(VMSAVE,24); 
    subplot(2,3,5)
    hold on
    plot(time(1:24:end)/year,ll(1:24:end))
    xlim([xx(1) xx(end)])
    set(gca,'XTick',xx,'XTickLabel',yy)
    title('Ice Volume')
    ylabel('m^3/m^2')
    grid on
    
    ll = smooth(SAsave,24); 
    subplot(2,3,6)
    hold on
    plot(time(1:24:end)/year,ll(1:24:end))
    xlim([xx(1) xx(end)])
    set(gca,'XTick',xx,'XTickLabel',yy)
    title('Total Surface Area')
    ylabel('m^2/m^2')
    grid on
   
end
    legend({'.1m','.25 m','.5 m','1 m','5 m','20 m'})
