ini_val=[0.38 0.04 0.06 0.04 0.7];
x_int=0.5;y_int=0.5;
% FEM data initialization
M = [ nely + 1 , nelx + 1 ];
EW = DW / nelx;  % length of element
EH = DH / nely;  % width of element
[ x ,y ] = meshgrid( EW * [ 0 :  nelx] , EH * [ 0 : nely]);
LSgrid.x = x(:);
LSgrid.y = y(:);     % coordinate of nodes
% Material properties
h=1;  %thickness
E=1;
nu=0.3;
%Parameter of MMA 
xy00=mmcfit;
N=length(xy00)/7;
xval=xy00;
xold1 = xy00;
xold2 = xy00;
%Limits of variable:[x0 ; y0  ; L ; t1 ; t2; t3; st]; 
xmin=[0 ; 0  ; 0.001 ; 0.001  ; 0.001 ; 0.001; -1.5];
xmin=repmat(xmin,N,1);
% xmin=[]%% 只需此行即可实现初始无组件
xmax=[DW ; DH ; (DW+DH)/2 ; (DW+DH)/5 ; (DW+DH)/5 ; (DW+DH)/5 ; 1.5];
xmax=repmat(xmax,N,1);
% xmax=[]%% 只需此行即可实现初始无组件
low   = xmin;
upp   = xmax;
m = 1;  %number of constraint
Var_num=7;  % number of design variables for each component
nn=Var_num*N;
c=1000*ones(m,1);
d=zeros(m,1);
a0=1;
a=zeros(m,1);
%Preparation FE analysis
nodenrs=reshape(1:(1+nelx)*(1+nely),1+nely,1+nelx);        
edofVec=reshape(2*nodenrs(1:end-1,1:end-1)-1,nelx*nely,1);   
edofMat=repmat(edofVec,1,8)+repmat([0 1 2*nely+[2 3 4 5] 2 3],nelx*nely,1);  
iK=kron(edofMat,ones(8,1))';
jK=kron(edofMat,ones(1,8))';
EleNodesID=edofMat(:,2:2:8)./2;    
iEner=EleNodesID';
[KE] = BasicKe(E,nu, EW, EH,h);   %  stiffness matrix k^s is formed
%Initialize iteration
p=6;                 
alpha=1e-3;            % parameter alpha in the Heaviside function
epsilon=4*min(EW,EH);  % regularization parameter epsilon in the Heaviside function
Phi=cell(N,1);        
Loop=1;
change=1;