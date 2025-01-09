%Forming Phi^s
xy00_his{1}=xy00;
for i=1:N
    Phi{i}=tPhi(xy00(Var_num*i-Var_num+1:Var_num*i),LSgrid.x,LSgrid.y,p);
end
%Union of components
tempPhi_max=Phi{1};
for i=2:N
    tempPhi_max=max(tempPhi_max,Phi{i});
end
Phi_max=reshape(tempPhi_max,nely+1,nelx+1);
Phi_max_his{1}=Phi_max;