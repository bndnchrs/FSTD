strs = {'SavedOutput/OneWeekSwell/Comp_Single/H25', ...
    'SavedOutput/OneWeekSwell/Comp_Single/H05' , ...
    'SavedOutput/OneWeekSwell/Comp_Single/H15'};

thicks = [5 15 25];

%%
for i = 1:length(strs)
    
    load(strs{i},'time','day','H','wattensave','psisave','HMSAVE','dt','concsave','v_group','meshR','R','Domainwidth','Lambda','HSAVE','Per');
    load('Swell/int_interp_coeff')
    
    
    sz = size(psisave);
    nt = sz(3);
    bret_num = 9;
    
    
    for  j = 1:nt-1
        
        numfloes = psisave(:,:,j)./meshR;
        rbar(i,j) = integrate_FD(numfloes,R',1);
        hbar(i,j) = integrate_FD(psisave(:,:,j),[H HMSAVE(j)],1);
        
        la(i,j) = polyval2(pv2,HSAVE(1),Per(bret_num));
        
        al_not(i,j) = exp(1).^(la(i,j));
        
        tau = Domainwidth ./v_group(bret_num);
        
        
        al_at(i,j) = al_not(i,j).*concsave(j)/(2*rbar(i,j));
      
        
        W_at(i,j) = 1./al_at(i,j);
        
        
        Afrac(i,j) = min(W_at(i,j)/Domainwidth,1);
        AF2(i,j) = min(wattensave(bret_num,j)/Domainwidth,1);
        FF(i,j) = Afrac(i,j) * (dt/tau);
        FF2(i,j) = AF2(i,j) * (dt/tau);
        
        
        if j == 1
            PS(i,j)  = .75;
            PS2(i,j) = .75;
        else
            PS(i,j) = PS(i,j-1) - FF(i,j)*PS(i,j-1);
            PS2(i,j) = PS2(i,j-1) - FF2(i,j)*PS2(i,j-1);
            
        end
        
        
        
    end
    
    subplot(1,3,i)
    
    plot(time/day,squeeze(psisave(30,thicks(i),1:end-1)))
    hold on
    plot(time/day,PS(i,1:length(time)))
    plot(time/day,PS2(i,1:length(time)))

    
    
end





