function gamma_ridge = calc_gamma_ridge(H,H_raft)
g_offset = (2/pi)*atan(10*((- .5 + H_raft))); 
gamma_ridge = ((1/pi)*atan(10*((2/pi)*atan(10*((H - H_raft)))))) +.5; 
gamma_ridge = min(gamma_ridge,1); 
gamma_ridge = max(gamma_ridge,0);  
end