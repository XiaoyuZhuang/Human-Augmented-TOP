% Calculating the finite difference quotient of H
H=Heaviside(Phi_max,alpha,nelx,nely,epsilon);
diffH=cell(N,1);
for j=1:N
    for ii=1:Var_num
        xy001=xy00;
        xy001(ii+(j-1)*Var_num)=xy00(ii+(j-1)*Var_num)+max(2*min(EW,EH),0.005);
        tmpPhiD1=tPhi(xy001(Var_num*j-Var_num+1:Var_num*j),LSgrid.x,LSgrid.y,p);
        tempPhi_max1=tmpPhiD1;
        for ik=1:j-1
            tempPhi_max1=max(tempPhi_max1,Phi{ik});
        end
        for ik=j+1:N
            tempPhi_max1=max(tempPhi_max1,Phi{ik});
        end
        xy002=xy00;
        xy002(ii+(j-1)*Var_num)=xy00(ii+(j-1)*Var_num)-max(2*min(EW,EH),0.005);
        tmpPhiD2=tPhi(xy002(Var_num*j-Var_num+1:Var_num*j),LSgrid.x,LSgrid.y,p);
        tempPhi_max2=tmpPhiD2;
        for ik=1:j-1
            tempPhi_max2=max(tempPhi_max2,Phi{ik});
        end
        for ik=j+1:N
            tempPhi_max2=max(tempPhi_max2,Phi{ik});
        end
        HD1=Heaviside(tempPhi_max1,alpha,nelx,nely,epsilon);
        HD2=Heaviside(tempPhi_max2,alpha,nelx,nely,epsilon);
        diffH{j}(:,ii)=(HD1-HD2)/(2*(max(2*min(EW,EH),0.005)));
    end
end