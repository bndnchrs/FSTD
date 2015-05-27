function [Al,Ao,Alf] = calc_lead_area(n,r,openwater,r_p)

Al = integrate_FD(n,((r+r_p).^2)./(r.^2),0) - integrate_FD(n,r*0 + 1,0); 

%%
Alf = max(Al-openwater,0); 
Al = min(Al,openwater);

Al = max(0,Al); 
Ao = openwater - Al; 
Ao = max(0,Ao); 


end