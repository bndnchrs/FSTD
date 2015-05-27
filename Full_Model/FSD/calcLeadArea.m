function [Al,Ao,Alf] = calcLeadArea(n,r,openwater)


Al = integrate_FD(n,((r+r(1)).^2)./(r.^2),0) - integrate_FD(n,r*0 + 1,0); 

%%
Alf = max(Al-openwater,0); 
Al = min(Al,openwater);
Al = max(0,Al); 
Ao = openwater - Al; 
Ao = max(0,Ao); 

end