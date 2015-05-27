Q_var = linspace(-9.9,.1,55);
num_plots = length(Q_var);

doThermo = 1;
doMech = 1;

scrsz = get(0,'ScreenSize');

Figlocs = figure('Position',[1 scrsz(4)/4,(2/3)*scrsz(3),3*scrsz(4)/4]);
FigNames = {Figlocs};
fignum = 1;
figtitles = {'VaryQ'};

fig_init = 1;

close all

Plot_Mult;

%%

SAVER = NaN + zeros(2,length(Q_var));

for j = 1:length(Q_var)
    
    STR = [num2str(Q_var(j)) '0']; 
    STR = STR(1:4); 
    strout = ['Output/VARYQ_CONVp' STR]
    
%    try load(strout,'concsave','T')
   if exist(strout,'file')  
       
       disp('moving')
       movefile(strout,[strout '.mat']); 
       
%         if min(concsave) == 0
%             
%             SAVER(1,j) = min(T(concsave == 0));
%             
%         end
%         
%         SAVER(2,j) = concsave(end)/(concsave(end) ~= 0);
        
        
 %   catch errload
 else      
        clearvars -except doThermo doMech Q_var num_plots QQ j Fig* fig* SAVER strout
        fig_init = 0;
        
        
        
        
        Init_General;
        Init_Thermo;
        Init_Mech;
        
        
        
        n = R.^(-2);
        n = n / sum(n);
        
        eps_I = -1e-7;
        eps_II = 0;
        
        
        if eps_I + eps_II == 0
            do_Mech = 0;
        end
        
        Q_surf = 0*Q_surf + Q_var(j);
        
        undriven = 0;
        
        FSD_Run;
        
        save(strout);
        
        % plot_in_place;
        
        if mod(j,25) == 1
            
            Plot_Mult;
            
        end
        
        hold all
        
        if min(concsave) == 0
            
            SAVER(1,j) = min(T(concsave == 0));
            
        end
        
        SAVER(2,j) = concsave(end)/(concsave(end) ~= 0);
    end
    
%    save(['Output/VARYQ_CONVp' STR '.mat']);
    
end