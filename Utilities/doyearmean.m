function field = doyearmean(field,meandur); 

% field is ~ by nt
%%
% first reshape to make is ~ by nt
sz = size(field); 

if max(sz) == sum(sz) - 1; 
    sizevec = 1;
    sz(end) = sz(1); 
else
    
sizevec = sz(1:end-1); 


end

%%


field = reshape(field,[sizevec meandur sz(end)/meandur]); 

