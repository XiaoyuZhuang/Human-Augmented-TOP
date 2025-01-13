tempPhi_max=Phi{1};
for i=2:N
    tempPhi_max=max(tempPhi_max,Phi{i});
end
for i=1:size(fixed_node,1)
    if fixed_node{i,1}<0
        tempPhi_max(fixed_node{i,2}>0)=-1;
    else
        tempPhi_max(fixed_node{i,2}>0)=2;
    end
end
Phi_max=reshape(tempPhi_max,nely+1,nelx+1);
% Phi_max_his{end+1}=Phi_max;
contourf(reshape(x,M),reshape(y,M),Phi_max,[0,0]);
hold on
for i=1:N
    contour(reshape(x , M), reshape(y , M),reshape(Phi{i},size(Phi_max)),[0,0],'LineWidth',2,'LineColor','k');
end
hold off;
axis equal;axis([0 DW 0 DH]);set(gca,'XTick',[],'YTick',[],'LineWidth',2);drawnow;