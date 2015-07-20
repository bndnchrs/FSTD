close all
clear all

here = pwd; 

cd('../../../FSTD-OUTPUT/Stormsorno')

%%
addpath('~/Research/floe-size-distribution-model/FSTD-OUTPUT/Movie_Scripts/')

names = {'new_NoStorms_Tmelt_1thick1m.mat','new_Storms_Tmelt_1thick1m.mat'};

movienames = {'Movies/NoStorms','Movies/Storms'}; 


 
load(names{2})

load(names{1},'DIAG'); 
No_Diag = DIAG; 
load(names{2},'DIAG'); 
Yes_Diag = DIAG; 

create_movie_FD(['Movies/stormsorno_conc'],1,[0 0 6 4])

figure; 
plot(FSTD.time/86400,[No_Diag.conc; Yes_Diag.conc],'linewidth',4); 
hold on
bar(FSTD.time(1:12:end)/86400,EXFORC.stormy(1:12:end)*.5,'g','edgecolor','none'); 
xlabel('Time (days)')
ylabel('Concentration')
title('Ice Concentration','fontname','Lucida Sans','Fontsize',24)
% legend({'No Storms','Yes Storms','Storms Active'})

hold on
grid on
box on

set(gca,'fontname','lucida sans','fontsize',12,'linewidth',2);



for i = 1:24:length(FSTD.time)
    
    g1 = scatter(FSTD.time(i)/86400,No_Diag.conc(i),300,'r');
    g2 = scatter(FSTD.time(i)/86400,Yes_Diag.conc(i),300,'r');    
   
    xlim([FSTD.time(1) 60]);
    ylim([0 1]); 
    
    create_movie_FD(['Movies/stormsorno_conc'],i,[0 0 6 4])
    
    drawnow
    
    delete(g1);
    delete(g2); 

    
end

create_movie_FD('close',1,[0 0 8 6])

%%

create_movie_FD(['Movies/stormsorno_oceT'],1,[0 0 6 4])

figure; 
plot(FSTD.time/86400,[No_Diag.OceanT; Yes_Diag.OceanT],'linewidth',4); 
hold on
bar(FSTD.time(1:12:end)/86400,EXFORC.stormy(1:12:end)*.5,'g','edgecolor','none'); 
xlabel('Time (days)')
ylabel('Ocean Temp')
title('Ocean Temperature','fontname','Lucida Sans','Fontsize',24)
legend({'No Storms','Yes Storms','Storms Active'})

hold on
grid on
box on

set(gca,'fontname','lucida sans','fontsize',12,'linewidth',2);



for i = 1:24:length(FSTD.time)
    
    g1 = scatter(FSTD.time(i)/86400,No_Diag.OceanT(i),300,'r');
    g2 = scatter(FSTD.time(i)/86400,Yes_Diag.OceanT(i),300,'r');    
   
    xlim([FSTD.time(1) 60]);
  % ylim([0 1]); 
    
    create_movie_FD(['Movies/stormsorno_oceT'],i,[0 0 6 4])
    
    drawnow
    
    delete(g1);
    delete(g2); 

    
end
    create_movie_FD('close',1,[0 0 8 6])


    %%

create_movie_FD(['Movies/stormsorno_R'],1,[0 0 8 6])

figure; 
plot(FSTD.time/86400,[No_Diag.Rmeanarea; Yes_Diag.Rmeanarea],'linewidth',4); 
hold on
bar(FSTD.time(1:12:end)/86400,EXFORC.stormy(1:12:end)*.5,'g','edgecolor','none'); 
xlabel('Time (days)')
ylabel('M')
title('Mean Floe Size','fontname','Lucida Sans','Fontsize',24)
legend({'No Storms','Yes Storms','Storms Active'})

hold on
grid on
box on

set(gca,'fontname','lucida sans','fontsize',24,'linewidth',2);



for i = 1:12:length(FSTD.time)
    
    g1 = scatter(FSTD.time(i)/86400,No_Diag.Rmeanarea(i),300,'r');
    g2 = scatter(FSTD.time(i)/86400,Yes_Diag.Rmeanarea(i),300,'r');    
   
    xlim([FSTD.time(1) 60]);
  % ylim([0 1]); 
    
    create_movie_FD(['Movies/stormsorno_R'],i,[0 0 8 6])
    
    drawnow
    
    delete(g1);
    delete(g2); 

    
end
    create_movie_FD('close',1,[0 0 8 6])


    
    
    
    
%

create_movie_FD(['Movies/stormsorno_V'],1,[0 0 8 6])

V0 = No_Diag.V_tot(1); 

figure; 
plot(FSTD.time/86400,[No_Diag.V_tot/V0; Yes_Diag.V_tot/V0],'linewidth',4); 
hold on
bar(FSTD.time(1:12:end)/86400,EXFORC.stormy(1:12:end)*.5,'g','edgecolor','none'); 
xlabel('Time (days)')
ylabel('Frac of Initial')
title('Ice Volume','fontname','Lucida Sans','Fontsize',24)
legend({'No Storms','Yes Storms','Storms Active'})

hold on
grid on
box on

set(gca,'fontname','lucida sans','fontsize',24,'linewidth',2);



for i = 1:12:length(FSTD.time)
    
    g1 = scatter(FSTD.time(i)/86400,No_Diag.V_tot(i)/V0,300,'r');
    g2 = scatter(FSTD.time(i)/86400,Yes_Diag.V_tot(i)/V0,300,'r');    
   
    xlim([FSTD.time(1) 60]);
    ylim([0 1]); 
    
    create_movie_FD(['Movies/stormsorno_V'],i,[0 0 8 6])
    
    drawnow
    
    delete(g1);
    delete(g2); 

    
end
    create_movie_FD('close',1,[0 0 8 6])


%%




create_movie_FD('Movies/stormsorno_FSD',1,[0 0 8 6])

No_Psi = squeeze(sum(No_Diag.psi,2)); 
Yes_Psi = squeeze(sum(Yes_Diag.psi,2)); 


figure; 


plot(FSTD.R,No_Psi(:,1),'-k','linewidth',2); 
g1 = plot(FSTD.R,No_Psi(:,1),'b','linewidth',2); 
g2 = plot(FSTD.R,Yes_Psi(:,1),'r','linewidth',2); 


legend({'Initial','No Storms','Yes Storms'})


set(gca,'fontname','lucida sans','fontsize',24,'linewidth',2);


for i = 1:12:length(FSTD.time)
    %%
    
    cla
    
hold on
grid on
box on
    
    
    plot(FSTD.R,No_Psi(:,1),'-k','linewidth',2); 
    plot(FSTD.R,No_Psi(:,i),'b','linewidth',2); 
    plot(FSTD.R,Yes_Psi(:,i),'r','linewidth',2); 
    ylabel('Ice Concentration')
    xlabel('Floe Size')

    legend({'Initial','No Storms','Yes Storms'})


    xlim([FSTD.R(1) FSTD.R(end)]);
    ylim([0 1]); 
    
    create_movie_FD(['Movies/stormsorno_FSD'],i,[0 0 8 6])
    
    drawnow
    
    
end
    
create_movie_FD('close',i,[0 0 6 6])

cd(here); 