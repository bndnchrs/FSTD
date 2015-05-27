function int = integrate_FD(Psi,quantity,norm)

% Need to normalize the distribution since it isn't, typically as there is
% open water

% Normalize

if norm
    denom = sum(Psi(:)); 
    if denom == 0
        denom = Inf; 
    end    
Psi = bsxfun(@rdivide,Psi,sum(Psi(:))); 
end


int = bsxfun(@times,Psi,quantity); 
int = sum(int(:)); 

if isnan(int)
    int = 0; 
end



end