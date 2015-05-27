%% Output Files



work2div(i) = sum(abs(diff))/sum(diff);
nsave(:,i) = n;
openersave(i) = opening;
HSAVE(i) = H;
OWSAVE(i) = openwater;
concsave(i) = sum(n);
diffsave(:,i) = diff;
MFS(i) = sum(R.*n)/sum(n);
Rmeanarea(i) = integrate_FD(n,R,1);
Rmeannum(i) = integrate_FD(numfloes,R,1);
smallfloes(i) = sum(n(R < 10));
smallmfs(i) = integrate_FD(n,R.*(R < r_raft),1);
bigmfs(i) = integrate_FD(numfloes,R.*(R >= r_raft),1);
bigfloes(i) = sum(n) - smallfloes(i);
T(i) = time(i)/(365*86400);
numsave(:,i) = n./(pi*R.^2);
pansave(i) = sum(pancake_area);
VSAVE(i) = concsave(i)*HSAVE(i); 
PSAVE(i) = Press;

openallsave(1:3,i) = [opening_mech; opening_ridge; opening_thermo];
dhdtallsave(1:3,i) = [dhdt; dhdt_mech; dhdt_thermo];
totalmovesave(1:3,i) = [sum(abs(diff(:))); sum(abs(diff_thermo(:))); sum(abs(diff_mech(:)))];