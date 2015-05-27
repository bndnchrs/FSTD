function PLOT_FSD_ONLY_Swell_Frac(loadstr,makemovies,singplot)
%% loadstr is the string where we load the file in
%% outname is the string that we make a qt file
% close all
addpath('/Users/Horvat/Desktop/Harvard_Work/floe-size-distribution-model/Full_Model/Output/')
addpath('/Users/Horvat/Desktop/Harvard_Work/floe-size-distribution-model/Full_Model/Utilities/')
addpath('/Users/Horvat/Desktop/Harvard_Work/floe-size-distribution-model/Full_Model/Movies/')
%% Read in the variables for plotting

if nargin < 2
    singplot = 0; 
end

if nargin < 1
    % default loading strings
    loadstr = 'SavedOutput/OneWeekSwell/2ndhump_no_interp';
    singplot = 0; 
end


% find the last subfolder location and make a movies directory in
% there
ll = find(loadstr=='/',1,'last');
outname = [loadstr(1:ll) 'movies/' loadstr(ll+1:end)];

% If there is no movies directory, we make it
if ~exist([loadstr(1:ll) 'movies/'],'dir')
    mkdir([loadstr(1:ll) 'movies/'])
end


load(loadstr,'psisave','R','Lambda','bret_ampl','concsave', ...
    'bret_spec','wattensave','tauswellsave','fulldiffswell','fulldiffsave','time', ...
    'year','day','Rmean*','H','HMSAVE','HSAVE','Per','numfloes','Domainwidth');




%%
FSD = squeeze(sum(psisave,2));
diff_swell = squeeze(sum(fulldiffswell,2));
in_FSD = diff_swell .* (diff_swell > 0); 
out_FSD = diff_swell .* (diff_swell < 0); 
in_FSD = bsxfun(@rdivide,in_FSD,sum(in_FSD,1)); 
out_FSD = bsxfun(@rdivide,out_FSD,sum(out_FSD,1)); 
sz = size(in_FSD); 
for i = 1:sz(2)-1; 
    Rmean_in(i) = integrate_FD(in_FSD(:,i),R',1);
    Rmean_out(i) = integrate_FD(out_FSD(:,i),R',1);
    number_of_floes(i) = integrate_FD(psisave(:,:,i+1),1./R'.^2,1);     
end



%%

if makemovies
    close all
end

if ~singplot
    lt = length(time); 
else
    lt = 1; 
end

for i = 1:lt
    
    
    
    PLOT_Singlet_Swell;
    
    if makemovies
        
        
        create_movie_FD(outname,i);
        
    end
    
end

if makemovies
    create_movie_FD('close')
end