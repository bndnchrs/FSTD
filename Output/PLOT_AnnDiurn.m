Outnames = {'SavedOutput/AnnDiurn/AnnDiurn_noql','SavedOutput/AnnDiurn/AnnOnly_noql',};

    subplot(1,2,1)

%%
for ii = 1:length(Outnames)
   
    load(Outnames{ii}); 
    
    for j = 12:length(time)-12
        dmaxr(ii,j) = max(drdtsave(j-11:j+12)); 
        dminr(ii,j) = min(drdtsave(j-11:j+12)); 
        dmaxh(ii,j) = max(dhdtsave(j-11:j+12)); 
        dminh(ii,j) = min(dhdtsave(j-11:j+12)); 
    end
end 
