Q_surf = 300*sin(2*pi*time/year); % Ocean surface heat flux
Q_diurn = 150*cos(2*pi*time/(day)); 
Q_surf = Q_surf + Q_diurn; 
%Q_surf = 300 + 0*Q_surf; 
%Q_surf = Q_surf + -150*sin(2*pi*(time- time(270)) / (24*dt)) + 50*(rand(1,length(Q_surf))-.5);

