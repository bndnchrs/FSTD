%% Drive_FD
% This routine initializes and then executes multiple runs as the main
% wrapper and driver of the FD code.


% Do the first initialization, which just loads in nr, hr, etc, etc.

% Surf_Flux = [-300:20:-50 -50:10:-10 -10:5:0];
% Surf_Flux = [Surf_Flux fliplr(-Surf_Flux)];


eps_1save = [-1e-7;  0; -sqrt(1/2)*1e-7];
eps_2save = [0; 1e-7; sqrt(1/2)*1e-7];

for KK = 1:2
    %%
    for JJ = 1:length(eps_1save)
        
        %% Initialization
        
%         Heating = Surf_Flux(JJ);
        
        Outname = ['SavedOutput/VaryEps/Q' num2str(2*(KK-1)+JJ)]
        
        if KK == 2
            Outname = [Outname 'Diurn_150']
        end
        
        
        clearvars -except 'Outname' '*_Flux' 'JJ' 'KK' 'eps_1save' 'eps_2save' 'SAVE*'
        
        try load(Outname,'concsave','smallfloes','HSAVE','HMSAVE','T')
            
            
            
            
            
        catch err_load
            
            disp('..')
            %% First initialize the main variables and overwrite main variables
            first_init = 1;
            
            nh = 10;
            nr = 15;
            
            dt = 86400/12;
            nt = round(10*365*86400/dt);
            % nt = 365
           
            eps_I = eps_1save(JJ);
            eps_II = eps_2save(JJ); 
            
            Initialize_FD;
            
            
            %% Overwrite Those Variables we want changed from modules
            
            Q_surf = -300*sin(2*pi*time/year);
            
            if KK == 2
                
                dtperday = day/dt;
                
                Q_seed = 150*sin(2*pi*time(1:dtperday)/day);
                
                Q_seed(dtperday/2 + 1) = 0;
                Q_seed = [Q_seed(1:dtperday/2) 0 -fliplr(Q_seed(2:dtperday/2))];
                
                Q_diurn = repmat(Q_seed,[1 nt*dt/day]);
                
                % Q_diurn = 150*cos(2*pi*time/day);
                
                Q_surf = Q_surf + Q_diurn;
                
            end
            
            psi = meshR.^(-2).*lognpdf(meshH,-1,1);
            psi = psi/sum(psi(:));
            
            %% Now initialize modules
            
            first_init = 0;
            
            do_FD = 1;
            do_Mech = 1;
            do_Thermo = 1;
            do_Diagnostics = 1;
            
            Initialize_FD;
            
            
            %% Actually Run the Model
            
            driven = 1;
            
            FD_Run;
            
            
            
            save(Outname);
            
            
        end
        
        % SAVE_CONC(JJ,:) = concsave;
        % SAVE_HEAT(JJ) = Heating;
        % SAVEPAN(JJ) = sum(pansave) ~= 0;
        
        subplot(2,3,3*(KK-1) + JJ)
        %     hold on
        
        
        plotyy(T,[concsave; smallfloes./concsave],T,[HSAVE;HMSAVE])
        
        
        
        %
        %    subplot(1,2,2)
        %     hold on
        %     plot(T,HSAVE)
             
             
        %     drawnow
        %
        %     if mean(concsave(end-365:end)) == 0
        %         scatter(Heating,min(T(concsave == 0)));
        %     else
        %         scatter(Heating,mean(concsave(end-365:end)));
        %     end
        
        
        
        %    concsave(end);
        
        %    drawnow
        
        
    end
    
end