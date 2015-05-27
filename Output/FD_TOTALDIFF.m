%% FD__TOTALDIFF


clear upper lower xpoints 

xpoints = [time/year time(end)/year]; 

% xpoints = [time/day time(end)/day + time(2)/day];

lower{1} = zeros(1,length(time)+1); 

countplot = 0; 

nums = [max(i-365*8,1) i]; 

lower{1} = lower{1}(nums(1):nums(2));
xpoints = xpoints(nums(1):nums(2)); 

summer = 0*xpoints; 

% Just in case we want to examine volume
multiplier = ones(size(meshH)); 

do_VOL = 1; 

if do_VOL == 1
    multiplier = meshH; 
end

%%

if do_Thermo
    
    % pancake change
    countplot = countplot + 1; 
    
    pansave(isinf(pansave)) = 0; 
    
    magval = dt*pansave(nums(1):nums(2))*multiplier(1,1);
    
    if exist('doMEANDIFF','var') && doMEANDIFF == 1
        magval = doyearmean(magval,364*4); 
    end
        
    magval = day/dt * magval; 
    upper{countplot} = magval; 
    summer = summer + upper{countplot}; 

    %%
    % Regular thermo change
    
    countplot = countplot + 1; 

    
    magval = .5*fulldiffthermo; 
    

        %%
    magval(1,1,:) = magval(1,1,:) - permute([pansave pansave(end)],[1 3 2]); 
    
    magval = bsxfun(@times,magval,multiplier);
    
    %%
    magval = dt*squeeze(abs(sum(sum(magval(:,:,nums(1):nums(2)),1),2)));
    magval = day/dt * magval; 
    upper{countplot} = magval';
    summer = summer + upper{countplot}; 

    
    
end
%%
if do_Mech
    countplot = countplot + 1; 
    magval = fulldiffmech; 
    
    magval = bsxfun(@times,magval,multiplier); 
 
    
    %%ho
    magval = dt*squeeze(sum(sum(abs(magval(:,:,nums(1):nums(2))),1),2));
    magval = day/dt * magval; 
    %%
    upper{countplot} = magval';
    summer = summer + upper{countplot}; 
    
end

%%

if do_Swell
    
    countplot = countplot + 1; 
    
    magval = fulldiffswell; 
    
    magval = bsxfun(@times,magval,multiplier); 
    magval = dt*squeeze(sum(sum(abs(magval(:,:,nums(1):nums(2))),1),2));
    magval = day/dt * magval; 
    
    upper{countplot} = magval';
    summer = summer + upper{countplot}; 
    
end

%%

for iterare = 1:countplot
%    upper{iterare} = upper{iterare}./summer; 
end
    

for iterare = 2:countplot
     lower{iterare} = upper{iterare-1}; 
     upper{iterare} = lower{iterare} + upper{iterare}; 
end

colors = {'m','b', 'r' ,'g','k'};

for iterare = 1:countplot
    jbfill(xpoints,upper{iterare},lower{iterare},colors{iterare}); 
%    jbfill(xpoints,upper{iterare},lower{1},colors{iterare})

end

%xlim([xpoints(1) xpoints(end)])
% ylim([0 1])

