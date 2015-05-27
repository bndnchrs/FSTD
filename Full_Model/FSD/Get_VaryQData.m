
cd('./Output');
FILES = dir('./')
for i = 1:length(FILES)
    names{i} = FILES(i).name;
end


counter = 1;
for jj = 1:length(names)
    if length(names{jj}) > 5
        if strcmp(names{jj}(1:5),'VARYQ') == 1
            load(names{jj});
            QNET(counter) = Q_surf(1);
            
            if min(concsave) == 0
                
                TZERO(counter) = min(T(concsave == 0));
                
            else
                
                TZERO(counter) = NaN;
            end
            
            STEADYCONC(counter) = concsave(end)/(concsave(end) ~= 0);
            
            STEADYDHDT(:,counter) = dhdtallsave(:,end);
            
            PANS(counter) = sum(pansave); 
            
            counter = counter + 1; 
        end
    end
end
