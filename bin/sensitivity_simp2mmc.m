% Sensitivities
df0dx=zeros(Var_num*N,1);
dfdx=zeros(Var_num*N,1);
for k=1:N
    df0dx(Var_num*k-Var_num+1:Var_num*k,1)=-2*(H-H_obj')*diffH{k};
    dfdx(Var_num*k-Var_num+1:Var_num*k,1)=sum(diffH{k})/4;
end
%MMA optimization
f0val =sum((H(:)-H_obj(:)).^2);
df0dx=-df0dx/max(abs(df0dx));
fval=A1/(DW*DH)-volfrac;
fval=-1;
dfdx=dfdx/max(abs(dfdx));
dfdx=zeros(Var_num*N,1);