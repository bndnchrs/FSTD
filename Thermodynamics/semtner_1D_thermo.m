function [dhdt,F_s,F_a,T_new] = semtner_1D_thermo(Q,h,T_0)
%% function [dhdt,T] = semtner_1D_thermo(Q,h)
% Q is the surface heat flux that is not the long-wave part
% h is the vector of ice thicknesses
% T_0 is the vector of ice temperature per thickness

% dhdt is the surface melt rate per thickness category
% F_s is the conductive flux per thickness category
% F_a is the surface heat budget (0 if not melting). 
% T is the temperature of the ice per thickness category

rho_0 = 917; %kg/m^3 density of ice
L_0 = 334000; %J/kg latent heat of freezing of ice
kappa_I = 2.034; %J/(s deg C m)
sigma = 5.67e-8; % Boltzmann constant
T_B = -2; % Degrees C (temp of bottom)

F_a = zeros(1,length(h)); 
F_s = F_a; 
dhdt = F_a; 

q_s = rho_0 * L_0 ; % Enthalpy of freezing/melting of surface ice

%% For each thickness 
for i = 1:length(h)
  
    %%
    H = h(i);
    T_ice = T_0(i);
    
    % The conductive heat flux from the ocean
    cond_HF = @(T_i) kappa_I * (T_i - T_B)./H;
    
    % The surface heat flux from the balance of fluxes - conductive
    surf_HF = @(T_i) Q + sigma*(T_i+273.14).^4 + cond_HF(T_i);
    
    % Find the temperature which equalizes the conductive flux and the
    % surface heat balance, near T_0.     
    T_new(i) = fzero(surf_HF,T_ice); % New ice temperature
 %%   
    % If the temperature is larger than the melting point of fresh ice
    if T_new(i) > 0
        
        % Set the temperature to 0
        T_new(i) = 0;
        % Calculate the budget at 0 temperature
        F_a(i) = surf_HF(T_new(i));
        F_s(i) = cond_HF(T_new(i));
        
        % The melting is now done so as to balance the heat budget
        dhdt(i) = (F_a(i) - F_s(i))/q_s;
        
    else
        
        dhdt(i) = 0;
        F_s(i) = cond_HF(T_new(i));
        
    end
    
end
    
    
    
