%-------------------------------------------------------
%    This is the file mmasub.m
%
function [xmma,ymma,zmma,lam,xsi,eta,mu,zet,s,low,upp] = ...
mmasub(m,n,iter,xval,xmin,xmax,xold1,xold2, ...
f0val,df0dx,fval,dfdx,low,upp,a0,a,c,d)
%epsimin = sqrt(m+n)*10^(-9);
epsimin = 10^(-10); 
raa0 = 0.01;
albefa = 0.4;  
asyinit = 0.001;
asyincr = 0.008;
asydecr = 0.006;
asyinit = 0.6;
asyincr = 1.2;
asydecr = 0.8;
% asyinit = 0.0000001;
% asyincr = 0.0000008;
% asydecr = 0.0000006;
% asyinit = 0.1;
% asyincr = 0.8;
% asydecr = 0.6;
epsimin = 10^(-9);
raa0 = 0.01;
move = 0.5;
albefa = 0.1;

asyincr = 0.8;
asydecr = 0.6;
asyinit = 0.05;

asyincr = 0.01;
asydecr = 0.01;
asyinit = 0.05;

eeen = ones(n,1);
eeem = ones(m,1);
zeron = zeros(n,1);

% Calculation of the asymptotes low and upp :
if iter < 4.5 % 前几步不启用
  low = xval - asyinit*(xmax-xmin);
  upp = xval + asyinit*(xmax-xmin);
else
  zzz = (xval-xold1).*(xold1-xold2);
  factor = eeen;
  factor(find(zzz > 0)) = asyincr;
  factor(find(zzz < 0)) = asydecr;
  low = xval - factor.*(xold1 - low);
  upp = xval + factor.*(upp - xold1);
  lowmin = xval - 10*(xmax-xmin);
  lowmax = xval - 0.01*(xmax-xmin);
  uppmin = xval + 0.01*(xmax-xmin);
  uppmax = xval + 10*(xmax-xmin);
%     if iter>20&&iter<100
%         lowmin = xval - 0.02*(xmax-xmin);
%   lowmax = xval - 0.01*(xmax-xmin);
%   uppmin = xval + 0.01*(xmax-xmin);
%   uppmax = xval + 0.02*(xmax-xmin);
%   end
  
  low = max(low,lowmin);
  low = min(low,lowmax);
  upp = min(upp,uppmax);
  upp = max(upp,uppmin);
end

% Calculation of the bounds alfa and beta :

zzz = low + albefa*(xval-low);
alfa = max(zzz,xmin);
zzz = upp - albefa*(upp-xval);
beta = min(zzz,xmax);

% Calculations of p0, q0, P, Q and b.

xmami = xmax-xmin;
xmamieps = 0.00001*eeen;
xmami = max(xmami,xmamieps);
xmamiinv = eeen./xmami;
ux1 = upp-xval;
ux2 = ux1.*ux1;
xl1 = xval-low;
xl2 = xl1.*xl1;
uxinv = eeen./ux1;
xlinv = eeen./xl1;
%
p0 = zeron;
q0 = zeron;
% p0 = max(df0dx,0);
% q0 = max(-df0dx,0);
p0(find(df0dx > 0)) = df0dx(find(df0dx > 0));
q0(find(df0dx < 0)) = -df0dx(find(df0dx < 0));
pq0 = 0.001*(p0 + q0) + raa0*xmamiinv;
p0 = p0 + pq0;
q0 = q0 + pq0;
p0 = p0.*ux2;
q0 = q0.*xl2;
%
% P = sparse(m,n);
% Q = sparse(m,n);
P = zeros(m,n);
Q = zeros(m,n);
% P = max(dfdx,0);
% Q = max(-dfdx,0);
P(find(dfdx > 0)) = dfdx(find(dfdx > 0));
Q(find(dfdx < 0)) = -dfdx(find(dfdx < 0));
PQ = 0.001*(P + Q) + raa0*eeem*xmamiinv';
P = P + PQ;
Q = Q + PQ;
P = P * spdiags(ux2,0,n,n);
Q = Q * spdiags(xl2,0,n,n);
b = P*uxinv + Q*xlinv - fval ;
%
%%% Solving the subproblem by a primal-dual Newton method
[xmma,ymma,zmma,lam,xsi,eta,mu,zet,s] = ...
subsolv(m,n,epsimin,low,upp,alfa,beta,p0,q0,P,Q,a0,a,b,c,d);




