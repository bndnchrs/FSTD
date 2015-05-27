function Drive_MovieMaking
% This is the second driver: this one creates movies from the .mat files
% which were created in drive_makeout
close all
clear all
%%

[fieldnames, titles, labels, deltas, deltaT, SS, Secx, Secy] = get_init; 
%%

% For running in parallel
matlabpool(8)
parfor i = 1:length(fieldnames)
    
%for i = 1:length(fieldnames)
    disp(fieldnames{i})
    make_movie(fieldnames{i},titles{i},labels{i},deltaT(deltas(i)),SS(i),Secx(i),Secy(i))
   
end
    
disp('Done Making Movies');

end



function [fieldnames, titles, labels, deltas, deltaT, SS, Secx, Secy] = get_init

% Function which initializes which fields will be outputted
% Also initializes the grid and the timing

%% Gridding and Timescales
X = ncread('state.0000000000.t001.nc','X');
Y = ncread('state.0000000000.t001.nc','Y');
Z = ncread('state.0000000000.t001.nc','Z');

save('grid','X','Y','Z'); 

T = ncread('state.0000000000.t001.nc','T');

T = T(1:3:end); 
deltaTstate = T(2) - T(1); % Time step interval for most fields

T = ncread('CheapDiag.0000000000.t001.nc','T');
T = T(1:3:end);
deltaTCheap = T(2) - T(1); %For CheapAML Diagnostics

T = ncread('OceFluxes.0000000000.t001.nc','T'); 
T = T(1:3:end);
deltaTFlux = T(2) - T(1); %For OceFlux Diagnostics


save('deltaT','deltaTstate','deltaTCheap','deltaTFlux'); 

% Field properties

SS =     [0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0]; % An x-y section?
Secx =   [0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0]; % An y-z section?
Secy =   [1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1]; % An x-z section?
deltas = [1,1,1,1,1,1,1,1,1,1,1,2,2,3,3,1,1,1,1]; %Which files is data from?

fieldnames = {
    'TempYSection'
    'TempXSection'
    'SSTemp'
    'SSS'
    'SSU'
    'SSEta'
    'RhoS'
    'RhoXSection'
    'RhoYSection'
    'SXSection'
    'SYSection'
    'LH'
    'Qnet'
    'FW'
    'Taux'
    'UXSection'
    'UYSection'
    'WXSection'
    'WYSection'
    };
    
titles = {
    'TempXZSection'
    'TempYZSection'
    'SST'
    'SSS'
    'SSU'
    'Eta'
    'RhoSurface'
    'RhoYZSection'
    'RHOXZSection'
    'SYZSection'
    'SXZSection'
    'LH'
    'Qnet'
    'FW'
    'TauX'
    'UYZSection'
    'UXZSection'
    'WXSection'
    'WYSection'
    };

labels = {
    'Temperature anomaly (deg K)'
    'Temperature anomaly (deg K)'
    'Temperature (deg K)'
    'Salinity (ppm)'
    'Velocity (m/s)'
    'Sea Surface Heigh (m)'
    'Density kg/m^3'
    'Density anomaly kg/m^3'
    'Density anomaly kg/m^3'
    'Salinity anomaly (ppm)'
    'Salinity anomaly (ppm)'
    'Latent Flux (W/m^2) (+ = increase theta)'
    'Net Heat Flux (W/m^2) (+ = increase theta)'
    'Freshwater Forcing (m/yr) (+ = decrease S)'
    'Zonal Wind Stress (N/m^2)'
    'Zonal Velocity (m/s)'
    'Zonal Velocity (m/s)'
    'Vertical Velocity (m/s)'
    'Vertical Velocity (m/s)'
    };

deltaT = [deltaTstate
    deltaTCheap
    deltaTFlux];

    

end

function make_movie(fieldname,out_str,label,deltaT,SS,Secx,Secy)

load(fieldname)

Horv_makemovie(field,out_str,SS,Secx,Secy,label,deltaT); 

end

function Horv_makemovie(input,file_string,SS,Secx,Secy,title_string,deltaT)

% This displays and makes a movie using the input data
% Input data should be nxmxt, where t is the time axis
% assumed that n refers to x, m to y, which necessitates us taking the
% transpose for Matlab's plotting function

% Input is a file, XxYxT in size with T being a time axis
% file_string is the name of the output file
% SS, Secx,Secy refer to whether or not the file being outputted is:
% SS: The Sea Surface Field
% Secx: A section, fixing x (y-z section)
% Secy: A section, fixing y (x-z section)

% title_string is the units-having title of the output movie
% deltaT is the timestep used in producing the model output. 

close all

disp(['Going to make the movie ' file_string '.qt']); 

load grid


nx = length(X);
ny = length(Y);
nz = length(Z);

Lx = max(X); dx = Lx/nx;
Ly = max(Y); dy = Ly/ny;
Lz = max(abs(Z)); dz = Lz / nz;

%Grid %Commented out is a centered grid
x = X; %x = x - mean(x);
y = Y; %y = y - mean(y); 
z = Z; %z = z - mean(z); 

  
sz = size(input); 
tlength = sz(3);

% Control in case input is not on C-grid

if (Secy == 1 || SS == 1) && sz(1) ~= nx; 
    disp('On different grid: rescaling');
    disp(['Original size of field was ' int2str(sz)]); 
    for i = 1:sz(1) - 1
      A(i,:,:) = input(i,:,:)*.5 + .5*input(i+1,:,:); 
    end
    input = A; 
    disp(['Now it is ' int2str(size(input))]); 
end

% Control in case the file is too long


while tlength > 1600
    disp(['The file is too long to process fast... (numT = ' int2str(tlength) '). Cutting it in half'])
    input = input(:,:,1:2:end); 
    deltaT = 2*deltaT; 
    sz = size(input);
    tlength = sz(3); 
end
%%
% At 1 km resolution

[X Y] = meshgrid(x,y);

X = X'; 
Y = Y'; 
if SS == 1
%X = X;
%Y = Y;
C = size(input);

% for i = 1:C(end)
%   input(:,:,i) = input(:,:,i)';
% end
 
% Xt = X; 
% X = Y; 
% Y = Xt; 
% X = X';
% Y = Y'; 

else if Secx == 1
        [X Y] = meshgrid(y,z); 
        
        X = X';
        Y = Y';
        else if Secy == 1
        [X Y] = meshgrid(x,z); 
    
        X = X';
        Y = Y';
            end
end
end

size(X);
size(Y);

%disp(' ')
%disp(['The file has size ' int2str(size(input))]);

%size(input)

xtop = max(max(max(input(:,:,2:end)))); 
xbot = min(min(min(input(:,:,2:end)))); 

%Out = VideoWriter(str)   f; 

hfig = figure;

h = pcolor(X,Y,input(:,:,tlength));
shading interp
colorbar
%set(h,'EdgeColor','None')

if SS == 1
xlabel('Zonal Distance (km)','FontSize',24,'FontName','Hoefler Text');

% Create ylabel
ylabel('Meridional Distance (km)','FontSize',24,'FontName','Hoefler Text');

else if Secx == 1
        
        xlabel('Meridional Distance (km)','FontSize',24,'FontName','Hoefler Text');

% Create ylabel
        ylabel('Depth (dm)','FontSize',24,'FontName','Hoefler Text');

    else if Secy == 1
      
        xlabel('Zonal Distance (km)','FontSize',24,'FontName','Hoefler Text');

% Create ylabel
    ylabel('Depth (dm)','FontSize',24,'FontName','Hoefler Text');

        end
    end
end

% Create title
title(title_string,'FontSize',16,'FontName','Hoefler Text');

set(gca,'nextplot','replacechildren');
caxis manual; % allow subsequent plots to use the same color limits
caxis([xbot xtop]); % set the color axis scaling to your min and max color limits
set(gcf,'Renderer','zbuffer');


%open(Out);

str = [file_string '.qt'];

MakeQTMovie('start',str);


for i = 1:tlength
    
    if mod(i,100) == 0
        disp(['step ' int2str(i) ' of ' int2str(tlength)]);
    end
    t = deltaT*(i-1);
    
    title([title_string ', t = ' secs2hms(t)],'FontSize',16,'FontName','Hoefler Text');

h = pcolor(X,Y,input(:,:,i));
%set(h,'EdgeColor','None')
shading interp
 colorbar
% frame = getframe(hfig); 
% writeVideo(Out,frame); 

%set(gcf, 'PaperUnits', 'inches'); set(gcf, 'PaperSize', [5 1]);
%  set(gcf, 'PaperPosition', [0 0 5 1]); %% [left, bottom, width, height];
  print('-djpeg',[file_string 'tmp.jpg'])
  MakeQTMovie('addimage',[file_string 'tmp.jpg'])

end

%close(Out)


MakeQTMovie finish

disp(['Made a new file named ' str]);

end
