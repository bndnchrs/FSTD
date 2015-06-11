% merge_floes.m 
% This code takes a thermodynamically growing ice cover, and merges floes
% together based on the probability of overlap of the new-growing regions

delA = pi * FSTD.R * THERMO.drdt * OPTS.dt; 

THERMO.K_merge = bsxfun(@times,delA,delA')/THERMO.Ao;


for r1 = 1:length(FSTD.R)
    for h1 = 1:length(FSTD.H) + 1
        for r2 = 1:length(FSTD.R)
            for h2 = 1:length(FSTD.H)+1
                Out_merge(r1,h1) = NumberDist(r1,h1) * NumberDist(r1,h2) * 