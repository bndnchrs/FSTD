
if ~(exist('undriven','var'))

    disp('UnDriven'); 
Init_General;

end


time_anal = 0;
tic
numtot = 0;

%%


for i = 1:nt
    
    if mod(i,year/dt) == 0
        fprintf('Year %d of %d \n',round(dt*i/year),round(dt*nt/year));
    end
    
    %%
%     if doMech == 1
%         
%         FSD_timestepping_staggered;
%         
%     else

        FSD_timestepping;
        
        
%    end
    
    
    
end

% save(outname);




REALTIME = toc;


fprintf('\n TOTAL TIME: %d seconds \n TOTAL NUMBER OF TIMESTEPS: %d \n \n ',length(R),nt,REALTIME,numtot);

fprintf('Average number of sub-timesteps is %d \n \n',round(numtot/nt))
fprintf('Each Individual Timestep Took %d seconds \n \n',REALTIME/numtot);
fprintf('Each Model Timestep Took %d seconds \n \n ',REALTIME/nt);

% end
