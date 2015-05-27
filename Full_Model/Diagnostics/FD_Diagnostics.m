%% FD_Diagnostics
% This file, executed every global timestep, computes diagnostics for
% saving.

if do_Diagnostics == 1
    
    %% Evaluate Regular Diagnostics
    
    if do_FD == 1
        % Volume smaller than the largest floe size
        Vless = psi(:,1:end-1);
                
        % Total Volume
        Vol = integrate_FD(Vless,H,0);
        VSAVE(i) = Vol;
        
        
        % Mean Ice Thickness
        Hmean = integrate_FD(psi,[H H_max],1);
        HSAVE(i) = Hmean;
        
        
        % FSD larger than a small cutoff
        FSDc = FSD.*(FSD > 1e-6);
        
        % psi larger than a small cutoff
        psic = psi.*(psi > 1e-6);
        
        % Mean Floe Size calculated by area fraction
        Rmeanarea(i) = integrate_FD(psi,R',1);
        
        % Mean Floe Size calculated by number of floes
        Rmeannum(i) = integrate_FD(numfloes,R',1);
        
        % Floe smaller than 10 m
        smallfloes(i) = sum(FSDc(R < 10));
        
        % Mean floe size of small floes
        smallmfs(i) = integrate_FD(FSDc,R.*(R < 10),1);
        
        % Mean floe size of large floes
        bigmfs(i) = integrate_FD(FSDc,R.*(R >= 10),1);
        
        % Concentration of large floes which obtain substantial area
        % coverage
        bigfloes(i) = sum(FSDc) - smallfloes(i);
        
        
        % Psi itself
        psisave(:,:,i+1) = psi;
        
        % Full difference
        fulldiffsave(:,:,i) = diff_FD; 
        
        % Open water formation
        openersave(i) = opening;
        
        % Open water fraction
        OWSAVE(i) = openwater;
        
        % Ice concentration
        concsave(i) = sum(psi(:));
        
        % Total amount of opening
        diffsave(i) = sum(diff_FD(:));
        
        % Maximum Thickness
        VMSAVE(i) = V_max; 
        
        % Maximum Floe thickness
        HMSAVE(i) = H_max;
        
        % Area fluxed into largest floe thickness
        VMISAVE(i) = V_max_in;
        
        % Volume in largest floe thickness
        Volex(i) = H_max*sum(psi(:,end));
        
        % Total volume of all floes
        TotVol(i) = Volex(i) + VSAVE(i);
        
        
        
    end
    
    %% Evaluate Mechanical Diagnostics
    if do_Mech == 1 && mag~=0
        
        % Re-evaluate small floe stuff in terms of rafting size
        fulldiffmech(:,:,i) = diff_mech; 
        
         % Floe smaller than rafting size
        smallfloes(i) = sum(FSDc(R < r_raft));
        
        % Mean floe size of small floes
        smallmfs(i) = integrate_FD(FSDc,R.*(R < r_raft),1);
        
        % Mean floe size of large floes
        bigmfs(i) = integrate_FD(FSDc,R.*(R >= r_raft),1);
        
        
        % Amount of outgoing or incoming area for rafting/ridging
        SAVE_OutRaft(i) = sum(Out_raft(:));
        SAVE_InRaft(i) = sum(In_raft(:));
        SAVE_InRidge(i) = sum(In_ridge(:));
        SAVE_OutRidge(i) = sum(Out_ridge(:));
        
        % Outgoing area multiplied by thickness squared to give a
        % rudimentary energy equivalent to work done
        SAVE_OutRaftWork(i) = sum(Out_raft(:).*(meshH(:).^2));
        SAVE_OutRidgeWork(i) = sum(Out_ridge(:).*(meshH(:).^2));
        
        % Ratio of area fluxed in total to opening amount
        work2div(i) = sum(abs(diff_FD(:)))/sum(diff_FD(:));
        
        % Total area flux accounted for from ridging
        ridgework(i) = sum(abs(Out_ridge(:)));
        
        % Total area flux from rafting
        raftwork(i) = sum(abs(Out_ridge(:)));
        
        % Opening required
        magsave(i) = mag;
        
        % Mean gamma, preference for ridging over rafting
        gamsave(i) = sum(ITD(ITD > H_raft));
        
        % First strain rate invariant
        divsave(i) = eps_I;
        
        % Second strain rate invariant
        eps2save(i) = eps_II;
        
        % Amount of opening due to leaving the domain
        opensave(i) = divopening;
        
        
    end
    
    %% Evaluate Thermodynamic Diagnostics
    
    if do_Thermo == 1 
        
        fulldiffthermo(:,:,i) = diff_thermo; 
        % Side growth rate
        drdtsave(i) = drdt;
        % Thickness growth rates at each floe thickness
        dhdtsave(:,i) = dhdt;
        % Ocean temperature
        Tsave(i) = T_ocean;
        % Heat fluxes saved
        Qsave(i,:) = [Q_o Q_lat Q_vert];
        % Total Surface area 
        SAsave(i) = SAmean;
        % Lead fraction 
        Alsave(i) = Al;
        % Edge-growth
        EGsave(i) = sum(sum(edgegrowth));
        % Basal Heat Flux
        bashf(i) = dhdt_bas*dt;
        % Surface Heat Flux
        surfhf(i) = dhdt_surf*dt;
        
        pansave(i) = pancakes; 
        % Pancake Growth
        
        % Positive Growth Side
        dtplus = diff_thermo.*(diff_thermo > 0);
        % Negative Growth Side
        dtmin = diff_thermo.*(diff_thermo < 0); 
       
    end
    
    if do_Swell == 1 && stormy(III,i) == 1
        
        fulldiffswell(:,:,i) = diff_swell; 
        wattensave(:,i) = W_atten; 
        tauswellsave(:,i) = tau_swell; 

        
    end
    
    clear FSDc psic Hmean Vless Vol
    
    
end

