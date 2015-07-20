%% FD_Diagnostics
% This file, executed every global timestep, computes diagnostics for
% saving. It is only called when DIAG.DO

ind = FSTD.i;

%% Evaluate Regular Diagnostics

if FSTD.DO
    % Total Volume for smaller than largest floe size
    DIAG.V_less(ind) = integrate_FD(FSTD.psi(:,1:end-1),FSTD.H,0);
    
    % Total Volue in largest floe category
    DIAG.Vmax(ind) = FSTD.H_max*sum(FSTD.psi(:,end));
    
    % Total volume
    DIAG.V_tot(ind) = DIAG.V_less(ind) + DIAG.Vmax(ind);
    
    
    % Mean Ice Thickness
    DIAG.H(ind) = integrate_FD(FSTD.psi,[FSTD.H FSTD.H_max],1);
    
    % Mean Floe Size calculated by area fraction
    DIAG.Rmeanarea(ind) = integrate_FD(FSTD.psi,FSTD.R',1);
    
    % Mean Floe Size calculated by number of floes
    DIAG.Rmeannum(ind) = integrate_FD(FSTD.NumberDist,FSTD.R',1);
    
    
    % Psi itself
    DIAG.psi(:,:,ind+1) = FSTD.psi;
    
    % Full difference
    DIAG.fulldiff(:,:,ind) = FSTD.diff;
    
    % Open water formation
    DIAG.opener(ind) = FSTD.opening;
    
    % Ice concentration
    DIAG.conc(ind) = sum(FSTD.psi(:));
    
    % Total amount of opening
    DIAG.diff(ind) = sum(FSTD.diff(:));
    
    % Maximum Floe thickness
    DIAG.H_max(ind) = FSTD.H_max;
    
    % Area fluxed into largest floe thickness
    DIAG.V_max_in(ind) = FSTD.V_max_in;
    
    
    
end

%% Evaluate Mechanical Diagnostics
if MECH.DO && MECH.mag~=0
    
    % Re-evaluate small floe stuff in terms of rafting size
    DIAG.fulldiffmech(:,:,ind) = MECH.diff;
    
    %         % Amount of outgoing or incoming area for rafting/ridging
    %         SAVE_OutRaft(ind) = sum(Out_raft(:));
    %         SAVE_InRaft(ind) = sum(In_raft(:));
    %         SAVE_InRidge(ind) = sum(In_ridge(:));
    %         SAVE_OutRidge(ind) = sum(Out_ridge(:));
    %
    %         % Outgoing area multiplied by thickness squared to give a
    %         % rudimentary energy equivalent to work done
    %         SAVE_OutRaftWork(ind) = sum(Out_raft(:).*(meshH(:).^2));
    %         SAVE_OutRidgeWork(ind) = sum(Out_ridge(:).*(meshH(:).^2));
    %
    % Ratio of area fluxed in total to opening amount
    DIAG.work2div(ind) = sum(abs(FSTD.diff(:)))/sum(FSTD.diff(:));
    
    % Total area flux accounted for from ridging
    DIAG.ridgework(ind) = sum(abs(MECH.Out_ridge(:)));
    
    % Total area flux from rafting
    DIAG.raftwork(ind) = sum(abs(MECH.Out_ridge(:)));
    
    % Opening required
    DIAG.magsave(ind) = MECH.mag;
    
    % Mean gamma, preference for ridging over rafting
    DIAG.gamsave(ind) = sum(FSTD.ITD(FSTD.ITD > MECH.H_raft));
    
    % First strain rate invariant
    DIAG.divsave(ind) = MECH.eps_I;
    
    % Second strain rate invariant
    DIAG.eps2save(ind) = MECH.eps_II;
    
    % Amount of opening due to leaving the domain
    DIAG.opensave(ind) = MECH.divopening;
    
    if MECH.simple_oc_sr
        DIAG.ocicfac = MECH.oc_to_ic;
    end
    
end

%% Evaluate Thermodynamic Diagnostics

if THERMO.DO
    
    DIAG.fulldiffthermo(:,:,ind) = THERMO.diff;
    DIAG.T_ice(:,ind) = THERMO.T_ice;
    % Side growth rate
    DIAG.drdt(ind) = THERMO.drdt;
    DIAG.dhdt(:,ind) = THERMO.dhdt;
    % Thickness growth rates at each floe thickness
    %    DIAG.thermo_dhdt(:,ind) = THERMO.dhdt;
    % Ocean temperature
    %  DIAG.Toc(ind) = T_ocean;
    % Heat fluxes saved
    DIAG.Qpartition(ind,:) = [THERMO.Q_o THERMO.Q_lat THERMO.Q_bas];
    
    DIAG.Q_ocean(ind) = EXFORC.Q_oc; 
    DIAG.Fc(ind,:) = THERMO.Q_cond; 

    % Total Surface area
    DIAG.SA(ind) = FSTD.SAmean;
    % Lead fraction
    DIAG.Al(ind) = THERMO.Al;
    DIAG.Ao(ind) = THERMO.Ao;
    
    % Edge-growth
    DIAG.EGsave(ind) = sum(sum(THERMO.edgegrowth));
    
    DIAG.pansave(ind) = THERMO.pancakes;
    % Pancake Growth
    
end

if SWELL.DO && EXFORC.stormy(ind) == 1
    
    DIAG.fulldiffswell(:,:,ind) = SWELL.diff;
    DIAG.wattensave(:,ind) = SWELL.W_atten;
    DIAG.tauswellsave(:,ind) = SWELL.tau_swell;
    
    
end


if OCEAN.DO
    DIAG.OceanT(ind) = OCEAN.T;
    DIAG.OceanS(ind) = OCEAN.S;
    DIAG.OceanQo(ind) = OCEAN.Q_o;
    DIAG.OCEANQoi(ind) = OCEAN.Q_oi;
    DIAG.Oceanpan(ind) = OCEAN.pancakes;
    DIAG.OceandTdt(ind) = OCEAN.dTdt;
    DIAG.OCELW(ind) = OCEAN.LW;
    DIAG.OCESW(ind) = OCEAN.SW;
    DIAG.OCESH(ind) = OCEAN.SH;
    DIAG.OCERELAX(ind) = OCEAN.Q_loss; 
end

