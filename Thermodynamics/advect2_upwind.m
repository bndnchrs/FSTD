function [du_out,lossl,lossu] = advect2_upwind(c,x,y,vx,vy,dt,flagxcorr,flagycorr)
%% advect2_upwind(psi,R,[H H_max],v_r,v_h,dt_sub)

if nargin < 7
    flagxcorr = 0; 
    flagycorr = 0; 
end

nx = length(x);
ny = length(y);

%% This way can do 1-D advection too
if nx >= 2
    dx = x(2) - x(1); 
    dx = [x(1) diff(x)];

else
    dx = x(1); 
end



if ny >= 2
dy = y(2) - y(1); 
dy = [y(1) diff(y)];
else
    dy = dx(1); 
end


%%

C = zeros(length(x) + 4, length(y) + 4); 
VX = C; 
VY = C; 

DX = zeros(length(x)+4,1) + dx(end); 
DY = zeros(length(y)+4,1) + dx(end); 
DX(3:end-2) = dx; 
DY(3:end-2) = dy; 

C(3:end-2,3:end-2) = c; 
VX(3:end-2,3:end-2) = vx; 
VY(3:end-2,3:end-2) = vy; 

vxpos = sign(VX); 
vypos = sign(VY); 

du = zeros(size(C));
%%
for i = 2:nx+3
    for j = 2:ny+3
        
        if vxpos(i,j) > 0
            du(i,j) = du(i,j) - abs(VX(i,j)/DX(i))*C(i,j); 
            du(i+1,j) = du(i+1,j) + abs(VX(i,j)/DX(i))*C(i,j); 
        else
            du(i,j) = du(i,j) - abs(VX(i,j)/DX(i))*C(i,j); 
            du(i-1,j) = du(i-1,j) + abs(VX(i,j)/DX(i))*C(i,j); 
        end
        
        if vypos(i,j) > 0
            du(i,j) = du(i,j) - abs(VY(i,j)/DY(j))*C(i,j); 
            du(i,j+1) = du(i,j+1) + abs(VY(i,j)/DY(j))*C(i,j); 
        else
            du(i,j) = du(i,j) - abs(VY(i,j)/DY(j))*C(i,j); 
            du(i,j-1) = du(i,j-1) + abs(VY(i,j)/DY(j))*C(i,j);
        end
        
    end
end
%%


[du_out,lossl,lossu] = correctedge(du,flagxcorr,flagycorr); 

du_out = du_out*dt; 
lossl = lossl*dt; 
lossu = lossu*dt; 

end