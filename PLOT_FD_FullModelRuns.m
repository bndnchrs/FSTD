%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.

close all

Outname = {'SavedOutput/Full_Runs/FullModel_2weekstorm_newmats', ...
    'SavedOutput/Full_Runs/ITDONLY', ...
    'SavedOutput/Full_Runs/FSDONLY', ...
    'SavedOutput/Full_Runs/AreaThickness', ...
    'SavedOutput/Full_Runs/HiblerThermo', ...
    'SavedOutput/Full_Runs/ThorndikeMech', ...
    'SavedOutput/Full_Runs/FSDONLY_NoSwell'
    };

numR = [50  1  50  1  1   1  50];
numH = [25 25   1  0  0  25   1];
DR =   [5  10  10 10 10  10  10];
DH =   [.1 .2   1  1  1   1   1];
HIB =  [0   0   0  0  1   0   0];
THORN =[0   0   0  0  0   1   0];
DOPLOT=[1   0   0  0  1   1   0];

%%

addpath('Output')
addpath('Utilities')

colplot = {'k','--g','--r','--c','r','g','--r'};


% f1 = figure;
f2 = figure;

ct = 0;

ct2 = 0;

load Utilities/Date_Identifiers




for III = 1:1
    
    load(Outname{III},'time','year','TotVol','concsave','fulldiff*','Rmean*','pan*','i','mesh*','do*','dt','day','HS*','Q*')
    
    
    
    
%     if DOPLOT(III) == 1
%         
%         ct = ct + 1;
%         
%         figure(f1)
%         
%         ARG = concsave;
%         %    ARG = reshape(concsave,364*4,[]);
%         %   ARG = squeeze(mean(ARG(:,20:25),2));
%         %%
%         
%         subplot_FD(3,1,.075,time/year,ARG,1,1,colplot{III},5)
%         
%         xlim([time(end)/year-1  time(end)/year])
%         
%         if ct == 1
%             title('Ice Concentration')
%         end
%         
%         set(gca,'xticklabel',mos(1:2:end),'xtick',monums(1:2:end) + floor(time(end)/year))
%         
%         ARG = TotVol;
%         %    ARG = reshape(TotVol,364*4,[]);
%         %    ARG = squeeze(mean(ARG(:,20:25),2));
%         
%         
%         
%         subplot_FD(3,1,.075,time/year,ARG,2,1,colplot{III},5)
%         
%         if ct == 1
%             title('Ice Volume')
%         end
%         
%         set(gca,'xticklabel',mos(1:2:end),'xtick',monums(1:2:end) + floor(time(end)/year))
%         
%         
%         xlim([time(end)/year-1  time(end)/year])
%         
%         ARG = TotVol./concsave; 
% 
% 
%         
%         
%         subplot_FD(3,1,.075,time/year,ARG,3,1,colplot{III},5)
%         
%         set(gca,'xticklabel',mos(1:2:end),'xtick',monums(1:2:end) + floor(time(end)/year))
%         
%         if ct == 1
%             title('Mean Ice Thickness')
%         end
%         %%
%         xlim([time(end)/year-1  time(end)/year])
%         
%         drawnow
%         
%         
%         if ct == 3
%             
%             legend({'Joint FSD/ITD','Hibler 79','Thorndike 75'},'Orientation','Horizontal','Position',[.3 .9 .4 .1])
%             
%             
%         end
%         
%         
%     end
    
        if DOPLOT(III) == 1 && III ~= 5
    
            ct2 = ct2 + 1;
    
            figure(f2)
    
            subplot_FD(5,2,.075,time/year,concsave,1,2)
            xlim([time(end)/year-1  time(end)/year])
            set(gca,'xticklabel',mos(1:2:end),'xtick',monums(1:2:end) + floor(time(end)/year))
    
            subplot_FD(5,2,.075,time/year,TotVol,2,2)
            xlim([time(end)/year-1  time(end)/year])
            set(gca,'xticklabel',mos(1:2:end),'xtick',monums(1:2:end) + floor(time(end)/year))
    
            subplot_FD(5,2,.075,time/year,Rmeanarea,3,2)
            xlim([time(end)/year-1  time(end)/year])
            set(gca,'xticklabel',mos(1:2:end),'xtick',monums(1:2:end) + floor(time(end)/year))
    
            subplot_FD(5,2,.075,time/year,HSAVE,4,2)
            xlim([time(end)/year-1  time(end)/year])
            set(gca,'xticklabel',mos(1:2:end),'xtick',monums(1:2:end) + floor(time(end)/year))
    
            subplot_FD(5,2,.075,time/year,Q_surf(1:length(time)),5,2)
            xlim([time(end)/year-1  time(end)/year])
            set(gca,'xticklabel',mos(1:2:end),'xtick',monums(1:2:end) + floor(time(end)/year))
    
    
            subplot_FD(sum(DOPLOT)-1,2,.075,0,0,ct2,1,colplot{III},5)
    
            FD_TOTALDIFF
    
            set(gca,'xticklabel',mos,'xtick',[xpoints(1):30:xpoints(end)])
    
            drawnow
    
        end
    
    
    
    
    
end
