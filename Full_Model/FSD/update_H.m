%% Since this is a simple 1-thickness model, we must conserve volume.

% Concentration change due to ridging/rafting
dcdtridge = -alpha_c*mag;

% Concentration change due to thermodynamics

dhdt = -dcdtridge * (H/sum(n)) + dhdt_thermo;

dh = dt_temp*dhdt;
H = H + dh;
H = max(h_p,H);
cinit = conc - sum(pancake_growth);
if sum(pancake_growth) ~= 0
    H = (H*cinit + sum(pancake_growth)*h_p)/(conc);
end

if H == 0 && Q < 0
    H = h_p;
end