addpath('Movies')

%% Movies for Swell Fracture


name = 'SavedOutput/OneWeekSwell/Gen_FSD';

load(name);

close all
skipit = 4;

%% Make FSD Movie
figure;

naught = sum(psisave(:,:,1),2);
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
hold on
box on
grid on
ylabel('Partial conc.')
xlabel('m')

xlim([R(1) 150])
ylim([0 max(naught(:))]);
scatter(2*R(10),max(naught(:))/2,300);
scatter(R(10),max(naught(:))/2,300);
g1 = plot(R,squeeze(sum(psisave(:,:,1),2)),'k');
% plot(Lambda,bret_spec,'--')

legend({'\lambda_{max}','\lambda_{max}/2','Floe Size Distribution'})

create_movie_FD([name '_FSD'],1,[0 0 10 10])
for i = 2:skipit:length(time)
    delete(g1)
    
    g1 = plot(R,squeeze(sum(psisave(:,:,i),2)),'k','linewidth',2);
    
    
    
    ylim([0 max(naught(:))])
    xlim([R(1) 150]);
    
    tittel = round(time(i)/day+1);
    
    title(['Day ',num2str(tittel)])
    legend({'\lambda_{max}','\lambda_{max}/2','Floe Size Distribution'})
    
    drawnow
    
    create_movie_FD([name '_FSD'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])

%% Make Mean Floe Size Movie
close all
figure;

xlabel('Time (day)')
ylabel('m')
plot(time/day,Rmeanarea);
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
hold on
box on
grid on
xlim([time(1)/day time(end)/day]);
g1 = scatter(time(i)/day,Rmeanarea(i),300,'r','filled');
create_movie_FD([name '_mfs'],1,[0 0 10 10])
title('Mean Floe Size')

for i = 2:skipit:length(time)
    
    delete(g1)
    g1 = scatter(time(i)/day,Rmeanarea(i),300,'r','filled');
    xlabel('Time (day)')
    ylabel('m')
    drawnow
    create_movie_FD([name '_mfs'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])

%% Make Mean Floe Size Movie



for ii = 1:length(HMSAVE)
    SASave(ii) = 0*concsave(ii) + integrate_FD(psisave(:,:,ii),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
end

close all
figure;

plot(time/day,SASave+concsave);
xlabel('Time (day)')
ylabel('m')
xlim([time(1)/day time(end)/day]);
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
hold on
box on
grid on
g1 = scatter(time(1)/day,concsave(1)+SASave(1),300,'r','filled');

create_movie_FD([name '_SA'],1,[0 0 10 10])
title('Mean Surface Area')

for i = 2:skipit:length(time)
    
    delete(g1)
    g1 = scatter(time(i)/day,concsave(i)+SASave(i),300,'r','filled');
    xlabel('Time (day)')
    ylabel('m^2')
    drawnow
    create_movie_FD([name '_SA'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 8.5 4])


%% Mechanical Movies

name = 'SavedOutput/OneWeekmech_newout/Compressing';
skipit = 4; 

load(name);

g1 = contourf([H HMSAVE(1)],R,log10(psisave(:,:,1)+eps),[-100 -12:1:-2],'showtext','on','textlist',[-8 -4 -2]);
colormap jet
xlabel('Ice Thickness (m)')
ylabel('Floe Size (m)')
set(gca,'linewidth',1)
set(gca,'FontSize',24)
title(['Day 0'])
set(gca,'FontName','Lucida Sans')
hold on
box on
grid on
create_movie_FD([name '_FSDITD'],1,[0 0 10 10])

%%

for i = 1:skipit:length(time)
    tic
    cla
    delete('g1')
    g1 = contourf([H HMSAVE(1)],R,log10(psisave(:,:,i)+eps),[-100 -12:1:-2],'showtext','on','textlist',[-8 -4 -2]);
    colormap jet
    tittel = round(time(i)/day);
    
    title(['Day ',num2str(tittel)])
    drawnow
    %create_movie_FD([name '_FSDITD'],i,[0 0 10 10])
    toc
end

create_movie_FD('close',i,[0 0 10 10])


%% Make Volume/Concentration

close all
figure;

V = Volex + VSAVE;

xlabel('Time (day)')
ylabel('m')
plot(time/day,concsave/concsave(1),'b');
hold on
plot(time/day,HSAVE/HSAVE(1),'r');
plot(time/day,V/V(1),'k');
legend({'Concentration','Thickness','Volume'});
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
box on
grid on
i = 1
xlim([time(1)/day time(end)/day]);
g1 = scatter(time(i)/day,concsave(i)/concsave(1),300,'b','filled');
g2 = scatter(time(i)/day,HSAVE(i)/HSAVE(1),300,'r','filled');
g3 = scatter(time(i)/day,V(i)/V(1),300,'k','filled');
create_movie_FD([name '_vars'],1,[0 0 10 10])
title('Ice Variables')

for i = 1:skipit:length(time)
    
    delete(g1)
    delete(g2)
    delete(g3)
    
    g1 = scatter(time(i)/day,concsave(i)/concsave(1),300,'b','filled');
    g2 = scatter(time(i)/day,HSAVE(i)/HSAVE(1),300,'r','filled');
    g3 = scatter(time(i)/day,V(i)/V(1),300,'k','filled');
    xlabel('Time (day)')
    ylabel('Mult. of Initial')
    drawnow
    create_movie_FD([name '_vars'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])


%% Thermodynamics Movies

name = 'SavedOutput/Freezeup/Gen_FSD';
load(name);

%%
g1 = contourf([H HMSAVE(1)],R,log10(psisave(:,:,1)+eps),[-100 -12:1:-2],'showtext','on','textlist',[-8 -4 -2]);
colormap jet
xlim([R(1) 2])
ylim([R(1) 25])
xlabel('Ice Thickness (m)')
ylabel('Floe Size (m)')
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
hold on
box on
grid on
create_movie_FD([name '_FSDITD'],1,[0 0 10 10])

endit = round(length(time)/8);

for i = 1:skipit:endit
    delete('g1')
    g1 = contourf([H HMSAVE(1)],R,log10(psisave(:,:,i)+eps),[-100 -12:1:-2],'showtext','on','textlist',[-8 -4 -2]);
    colormap jet
    tittel = round(time(i)/day);
    
    title(['Day ',num2str(tittel)])
    drawnow
    create_movie_FD([name '_FSDITD'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 10 10])



%% Make Area Growth
close all
figure;

agrowth = sum(sum(fulldiffthermo,2),1);
agrowth = squeeze(agrowth(1:end-1));
agrowth = agrowth - pansave';


xlabel('Time (day)')
ylabel('m')



plot(time/day,agrowth*day,'b');
hold on
plot(time/day,pansave*day,'r');
legend({'Lateral Growth','Open Water Growth'});
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
box on
grid on
xlim([time(1)/day time(endit)/day]);
i = 1;
g1 = scatter(time(i)/day,agrowth(i)*day,300,'b','filled');
g2 = scatter(time(i)/day,pansave(i)*day,300,'r','filled');
create_movie_FD([name '_agrowth'],1,[0 0 10 10])
title('Ice Area Growth')

for i = 1:skipit:endit
    
    delete(g1)
    delete(g2)
    
    
    g1 = scatter(time(i)/day,agrowth(i)*day,300,'b','filled');
    if pansave(i) ~= 0
        g2 = scatter(time(i)/day,pansave(i)*day,300,'r','filled');
    else
        g2 = scatter(time(i)/day,pansave(i)*day,.01,'r','filled');
    end
    xlabel('Time (day)')
    ylabel('Frac. per day')
    drawnow
    create_movie_FD([name '_agrowth'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])


% Make Concentration
close all
figure;

agrowth = sum(sum(fulldiffthermo,2),1);
agrowth = squeeze(agrowth(1:end-1));
agrowth = agrowth - pansave';


xlabel('Time (day)')
ylabel('m')



plot(time/day,concsave,'k');
hold on
%legend({'Ice Concentration'});
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
box on
grid on
xlim([time(1)/day time(endit)/day]);
i = 1;
g1 = scatter(time(i)/day,concsave(i),300,'k','filled');
create_movie_FD([name '_c'],1,[0 0 10 10])
title('Ice Concentration')

for i = 1:skipit:endit
    
    delete(g1)
    delete(g2)
    
    
    g1 = scatter(time(i)/day,concsave(i),300,'k','filled');
    
    xlabel('Time (day)')
    ylabel('Ice Conc.')
    drawnow
    create_movie_FD([name '_c'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])

% Make Volume
close all
figure;

agrowth = sum(sum(fulldiffthermo,2),1);
agrowth = squeeze(agrowth(1:end-1));
agrowth = agrowth - pansave';


xlabel('Time (day)')
ylabel('m')
V = Volex + TotVol;


plot(time/day,V,'k');
hold on
%legend({'Ice Concentration'});
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
box on
grid on
xlim([time(1)/day time(endit)/day]);
i = 1;
g1 = scatter(time(i)/day,V(i),300,'k','filled');
create_movie_FD([name '_V'],1,[0 0 10 10])
title('Ice Volume')

for i = 1:skipit:endit
    
    delete(g1)
    delete(g2)
    
    
    g1 = scatter(time(i)/day,V(i),300,'k','filled');
    
    xlabel('Time (day)')
    ylabel('Ice Vol.')
    drawnow
    create_movie_FD([name '_V'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])

%% Swell Fracture Movies

name = 'SavedOutput/OneWeekSwell/Gen_FSD';
load(name);

%%
g1 = contourf([H HMSAVE(1)],R,log10(psisave(:,:,1)+eps),[-100 -12:1:-1],'showtext','on','textlist',[-8 -4 -2]);
colormap jet
xlim([H(1) H(end)])
ylim([R(1) R(end)])
xlabel('Ice Thickness (m)')
ylabel('Floe Size (m)')
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
hold on
box on
grid on
create_movie_FD([name '_FSDITD'],1,[0 0 10 10])

endit = round(length(time)/2);

for i = 1:skipit:endit
    delete('g1')
    g1 = contourf([H HMSAVE(1)],R,log10(psisave(:,:,i)+eps),[-100 -12:1:-2],'showtext','on','textlist',[-8 -4 -2]);
    colormap jet
    tittel = round(time(i)/day+1);
    
    title(['Day ',num2str(tittel)])
    drawnow
    create_movie_FD([name '_FSDITD'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 10 10])


% FSD

close all
figure;

FSD = squeeze(sum(psisave,2));


xlabel('Floe Size (m)')

plot(R,FSD(:,1),'--b');
hold on
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
box on
grid on
xlim([R(1) R(end)]);
i = 1;
g1 = plot(R,FSD(:,1),'k');
create_movie_FD([name '_FSD'],1,[0 0 10 10])
tittel = round(time(i)/day+1);
title(['Day ',num2str(tittel)])
legend({'Initial FSD','Current FSD'});


%
for i = 1:skipit:endit
    
    delete(g1)
    
    g1 = plot(R,FSD(:,i),'k');
    
    xlabel('Floe Size (m)')
    ylabel('Floe Size Dist.')
    tittel = round(time(i)/day+1);
    title(['Day ',num2str(tittel)])
    drawnow
    create_movie_FD([name '_FSD'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])
% Make Mean Floe Size
close all
figure;

xlabel('Time (day)')
ylabel('m')



plot(time/day,Rmeanarea,'k');
hold on
%legend({'Ice Concentration'});
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
box on
grid on
xlim([time(1)/day time(endit)/day]);
i = 1;
g1 = scatter(time(i)/day,Rmeanarea(i),300,'k','filled');
create_movie_FD([name '_R'],1,[0 0 10 10])
title('Mean Floe Size')

for i = 1:skipit:endit
    
    delete(g1)
    
    g1 = scatter(time(i)/day,Rmeanarea(i),300,'k','filled');
    
    xlabel('Time (day)')
    ylabel('m')
    drawnow
    create_movie_FD([name '_R'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])


%
close all
figure;


xlabel('Wavelength (m)')
ylabel('m')

plot(Lambda,bret_spec,'k');
hold on
set(gca,'linewidth',1,'ytick',[])
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
box on
grid on
xlim([R(1) R(end)]);
i = 1;
create_movie_FD([name 'bretspec'],1,[0 0 10 10])
tittel = round(time(i)/day+1);
title('Wave Spectrum (normalized)')
% legend({'Initial FSD','Current FSD'});
ylabel('m')
xlabel('Wavelength (m)')

1%
for i = 1:skipit:endit
    
    %delete(g1)
    
    %g1 = plot(R,FSD(:,i),'k');
    
    % xlabel('Floe Size (m)')
    % ylabel('Floe Size Dist.')
    %tittel = round(time(i)/day+1);
    %title(['Day ',num2str(tittel)])
    drawnow
    create_movie_FD([name 'bretspec'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 10 10])

% Make Floe Number
close all
figure;

xlabel('Time (day)')
ylabel('m')

for ii = 1:length(HMSAVE)
    Perim(ii) = 0*concsave(ii) + integrate_FD(psisave(:,:,ii),2*bsxfun(@rdivide,[H HMSAVE(ii)],R'),1);
    Perim(ii) = Perim(ii)/HSAVE(1);
end



plot(time/day,Perim/Perim(1),'k');
hold on
%legend({'Ice Concentration'});
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
box on
grid on
xlim([time(1)/day time(endit)/day]);
i = 1;
g1 = scatter(time(i)/day,Perim(i)/Perim(i),300,'k','filled');
create_movie_FD([name '_SA'],1,[0 0 10 10])
title('Mean Exposed Floe Perimeter')

for i = 1:skipit:endit
    
    delete(g1)
    
    g1 = scatter(time(i)/day,Perim(i)/Perim(1),300,'k','filled');
    
    xlabel('Time (day)')
    ylabel('Frac of init.')
    drawnow
    create_movie_FD([name '_SA'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])


%% Longterm reasons
name = '/Users/Horvat/Desktop/Harvard_Work/floe-size-distribution-model/Full_Model/SavedOutput/Full_Runs/FullModel_2weekstorm_bigger';
load(name,'time','dt','day','fulldiff*','do_*','meshH','Q_Surf','pansave','meshR','R','H','HMSAVE','year','stormy','HSAVE','concsave','TotVol','Volex','VSAVE','Rmean*','Q_surf','psisave')

%
skipit = 7*4; % Weekly

%
g1 = contourf([H HMSAVE(1)],R,log10(psisave(:,:,1)+eps),[-100 -12:1:-2],'showtext','on','textlist',[-8 -4 -2]);
colormap jet

xlim([H(1) HMSAVE(1)])
ylim([R(1) R(end)])
xlabel('Ice Thickness (m)')
ylabel('Floe Size (m)')
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
hold on
box on
grid on
title(['Year ',num2str(0)])
    caxis([-12 -2])

create_movie_FD([name '_FSDITD'],1,[0 0 10 10])

%
endit = round(length(time)/5);

%
tick_frac = [-0.0585    0.0248    0.1081    0.1914    0.2747    0.3580    0.4417    0.5250    0.6083    0.6916    0.7749    0.8582];
tick_frac = [tick_frac(2:end) tick_frac(end)+.0833];
mos = {'Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep'};
%
for i = 1:skipit:endit
    tic
    cla
    
    g1 = contourf([H HMSAVE(1)],R,log10(psisave(:,:,i)+eps),[-100 -12:1:-1],'showtext','on','textlist',[-8 -4 -2]);
    colormap jet
    tittel = floor(time(i)/year + .7884);
    title(['Year ',num2str(tittel)]); % ', ' mos{b}])
    drawnow
    caxis([-12 -1])
    create_movie_FD([name '_FSDITD'],i,[0 0 10 10])
    toc
end

create_movie_FD('close',i,[0 0 10 10])

%%

close all
figure;

FSD = squeeze(sum(psisave,2));


xlabel('Floe Size (m)')
hold on
set(gca,'linewidth',1)
set(gca,'FontSize',24)
set(gca,'FontName','Lucida Sans')
box on
grid on
xlim([R(1) R(end)]);
i = 1;
g1 = loglog(R,FSD(:,1),'k');
set(gca,'YScale','log','XScale','log')
create_movie_FD([name '_FSD'],1,[0 0 10 10])
tittel = floor(time(i)/year + .7884);
title(['Year ',num2str(tittel)])
% legend({'Initial FSD','Current FSD'});


for i = 1:skipit:endit
    
    delete(g1)
    
    g1 = loglog(R,FSD(:,i),'k');
    xlim([5 R(end)])
    ylim([.0001 .1])
    xlabel('Floe Size (m)')
    ylabel('Floe Size Dist.')
    tittel = floor(time(i)/year + .7884);
    title(['Year ',num2str(tittel)])
    drawnow
    create_movie_FD([name '_FSD'],i,[0 0 10 10])
    
end

create_movie_FD('close',i,[0 0 4 3])

%%
% Make Ice Thickness

PP = {Q_surf(1:length(time)),HSAVE,VSAVE+Volex,concsave};
ender = {'Q','H','V','C'};
mult = [100,.2,.2,.2]; 
ppn = {'Net Heat Flux','Mean Thickness','Ice Volume','Ice Concentration'};
ppy = {'W/m^2','m','m^3',''};
ylers = {[-300 300],[0 2],[0 2],[0 1]};

for jj = 1:length(PP)
    
f1 = figure;

xlab = {'S','O','N','D','J','F','M','A','M','J','J','A'};
ticks = [23.9415 24.0248 24.1081 24.1914 24.2747 24.3580 24.4417 24.5250 24.6083 24.6916 24.7749 24.8582];
lims = [23.9315 24.9315];

tl = cell2mat(xlab); 

tl = repmat(tl,[1 ceil(time(end)/year)]); 
tl = mat2cell(tl',300);
ticks = tick_frac + 0; 
tick_frac = [-0.0585    0.0248    0.1081    0.1914    0.2747    0.3580    0.4417    0.5250    0.6083    0.6916    0.7749    0.8582];

tfrac = tick_frac(1):.0833:time(end)/year;
lims = lims - 20;
ticks = ticks - 20;
splot = [1 2 3 6 9];

plotter =  PP{jj};
pnames = {ppn{jj}};
ylabs = {ppy{jj}};

%%
%subplot(3,3,splot(ii));
plot(time/year,plotter(1,:),'k');
hold on

bar(time/year,stormy(1,:)*mult(jj),'g','edgecolor','g')
grid on
xlim(lims)
ylim(ylers{jj})
set(gca,'xtick',ticks,'xticklabel',xlab,'FontName','Lucida Sans','FontSize',8);
ylabel(ylabs{1})
title(pnames{1});
yl = get(gca,'ylim');
g = scatter(time(1)/year,plotter(1),300,'r');
xlim(lims);
    set(gca,'xtick',tfrac,'xticklabel',tl,'FontName','Lucida Sans','FontSize',8);

create_movie_FD([name '_' ender{jj}],1,[0 0 4 4])

%%

for ii = 1:skipit:endit
    %%
    yr = ceil(time(ii)/year);
    if yr > 1
        lims = [tick_frac(1)+yr-1 tick_frac(1)+yr];
        ticks = tick_frac + yr-1;
    else
        lims = [tick_frac(1) tick_frac(1)+1];
        ticks = tick_frac;
    end
    
    limbot = [time(ii)/year - 1 time(ii)/year];
    if limbot(1) < 0
        limbot = [0 1];
    end
    
    
    delete(g);
    g = scatter(time(ii)/year,plotter(ii),300,'r');
    xlim(lims);
    set(gca,'xtick',tfrac,'xticklabel',tl,'FontName','Lucida Sans','FontSize',8);
    create_movie_FD([name '_' ender{jj}],i,[0 0 4 4])

    drawnow
end

create_movie_FD('close',1,[0 0 10 10])


end
