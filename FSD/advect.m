function du = advect(u0,v,dt,x,dx)
%%

F=.99;          
if abs(v) ~= 0% saety factor for time step
dt=F*dx/abs(v); % time step based on von Neumann stability
else 
    du = 0; 
    return
end
C =v*dt/dx;                    % 
% 
u = u0;                  % define correct sized numerical solution array
N = length(u0); 
%                              
% Begin the time marching algorithm
%

 t=dt;               % current time for outputted solution
 u0=[0 u0 0];       % insert ghost value (appropriate to numerial scheme)
 for i=2:N+1
    u(i)=0.5*u0(i+1)*(1-C)+0.5*u0(i-1)*(1+C);     % LF algorithm    
 end
    u(1) = 0.5*u0(2)*(1-C); 
    uNp2 = 0.5*u0(N+1)*(1+C);
    %u(2) = u(2) + u(1); 
    u(N+1) = u(N+1) + uNp2; 
   %  plot(x,u(2:N+1),'r+')  % plot (omitting ghost values) of numerical and exact solutions
   %  xlabel('x')
   %  ylabel('concentration u')
   %  title('comparison of solutions to du/dt + v du/dx = 0, + numerical (LF), o analytical')
   %  pause(0.03)             % pause in seconds between plots
     u=u(2:N+1);
     u0 = u0(2:N+1); 
     du = (u - u0)/dt; % copy solution to initial conditions for next iteration
     u=[];                   % empty the solution vector (actually it will be overwritten) 

end