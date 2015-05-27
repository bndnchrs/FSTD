function gamma_swell = calc_out_swell_FD(Per,R)
% this routine creates the outgoing matrix which says into which floe size
% a given floe will fracture

%%
g = 9.81; 

gamma_swell = zeros(1,length(Per)); 

lambda = Per.^(2)*g/(2*pi);

sizeout = lambda / 2; 

for i = 1:length(Per)

    out_size = sizeout(i); 
    [~, loc] = min(abs(R - out_size)); 
    gamma_swell(i) = loc; 
    
end

        