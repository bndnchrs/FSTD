function Prob_frac = get_prob_frac_FD(bret_ampl,rayleigh,R,H,epscrit,Per)
% this function computes the probability transfer function P(r,T), which is
% zero when no waves break floes. It has integral 1 when waves do break
% floes and the relative proportion in each floe class depends on the
% rayleigh distribution of wave heights
%%

% Accel due to gravity. Used for sgw dispersion relation
g = 9.81; 

% maximum attained stress at each thickness and wavelength
eps_max = (2*pi)^4 * 2 ^(-2) * bsxfun(@times,H,bret_ampl'.* Per'.^(-4));
eps_max = permute(eps_max,[1 3 2]); 

% Rayleigh distribution of wave heights

% Useful for comparing R and lambda/2
Rrep = repmat(R',[1,length(H),length(Per)]); 
Rrep = permute(Rrep,[3 1 2]); 

% DWSGW disp. rel
Lambda = Per.^(2)*g/(2*pi);
Lamrep = repmat(Lambda',[1,length(R),length(H)]); 

%%


% If floes are too small they will surf and not break
isbigger = Rrep > Lamrep/2; 

% Numerator has heaviside function in it if floes aren't big enough
num = rayleigh .* isbigger; 

% Numerator has heaviside function in it if not enough straining
num = bsxfun(@times,num,(eps_max > epscrit)); 

% Normalizing all those which will break by taking the sum over all lamda
denom = sum(num,1); 

% Those that won't will be sent to 0. 
denom(denom == 0) = Inf; 

% Prob_frac should be nP by nR by nH

Prob_frac = bsxfun(@rdivide,num,denom); 
        

end