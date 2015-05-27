close all
clear all


doThermo = 1;
doMech = 1;

fprintf('INITIALIZING MAIN VARIABLES \n')

Init_General;
Init_Thermo;
Init_Mech;
scrsz = get(0,'ScreenSize');

OutNames = {'NoMech','PureConv','PureShear','Mixed'};

OutNames_Diurn = {'NoMech_Diurn','PureConv_Diurn','PureShear_Diurn','Mixed_Diurn'};
SaveNames = {'FSD_Conv_None_1','FSD_Conv_None_2','FSD_Shear_1','FSD_Shear_2'}; 

figtitles = OutNames;

eps_1_save = [0; -3e-7; 0; -3e-7 / sqrt(2)];
eps_2_save = [0; 0; -3e-7; -3e-7 / sqrt(2)];

fig_init = 1;

allexist = 1;

for kk = 1:length(eps_1_save)
    
    strout = ['Output/VaryEps/' OutNames{kk} '.mat'];
    if ~exist(strout,'file')
        allexist = 0;
    end
    
    
end

if allexist
    
    Fig1 = figure('Position',[1 scrsz(4)/4,(2/3)*scrsz(3),3*scrsz(4)/4]);
    Fig2 = figure('Position',[1 scrsz(4)/4,(2/3)*scrsz(3),3*scrsz(4)/4]);
    Fig3 = figure('Position',[1 scrsz(4)/4,(2/3)*scrsz(3),3*scrsz(4)/4]);
    Fig4 = figure('Position',[1 scrsz(4)/4,(2/3)*scrsz(3),3*scrsz(4)/4]);
    
    FigNames = {Fig1,Fig2,Fig3,Fig4};
    
end


for jj = 1:length(eps_1_save)
    
    if ~ allexist
        fprintf('DOING THE %s RUN \n',OutNames{jj})
        fprintf('THIS WILL TAKE %d YEARS OF MODEL TIME \n',round(dt*nt/year));
        fprintf('WHICH IS A MINIMUM OF %d INTERNAL MODEL STEPS \n',nt)
    else
        fprintf('PLOTTING THE %s RUN \n',OutNames{jj})
    end
    
    
    
    %%
    strout = ['Output/VaryEps/' OutNames_Diurn{jj} '.mat'];
    
    
    if exist(strout,'file')
        %        clearvars -except doThermo doMech i Fig* fig* SAVER strout
        
        
        if allexist
            
            typenum = jj;
            
                        plot_in_place(typenum,strout,FigNames,OutNames_Diurn{jj});

            
        else
            
            fprintf('%s Exists \n',OutNames_Diurn{jj})
            
        end
    else
        
        
        Init_General;
        
        
        n = R.^(-2);
        n = n / sum(n);
        
        eps_I = eps_1_save(jj);
        eps_II = eps_2_save(jj);
        
        
        if eps_I + eps_II == 0
            doMech = 0;
        else
            doMech = 1;
        end
        undriven = 0;
        
        Init_General;
        Init_Thermo;
        Init_Mech;
        
        
        
        %%
        FSD_Run;
        
        save(strout);
        
        
    end
    
    
    
end

%%

for i = 1:length(FigNames)
    saveas(FigNames{i},['Output/VaryEps/' SaveNames{i} '.fig'])
end
