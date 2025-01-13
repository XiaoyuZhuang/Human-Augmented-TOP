% penalK = 3; ft = 2; ftBC = 'N'; eta = 0.5; beta = 6;
% penalG = 3; nEig = 1; prSel = {['B','C','V'], [1.2,0.15]};
% [mu,sigma_v]=FEA_BuckStress0(x,F,nelx,nely,penalK,rmin,ft,ftBC,eta,beta,Lx,penalG,nEig,prSel,x0)
function [BLF,vonMisesStress]=FEA_BuckStress1(x,F,nelx,nely,penalK,rmin,ftBC,Lx,penalG,nEig,prSel,fixeddofs)
% penalK = 3; ft = 2; ftBC = 'N'; eta = 0.5; beta = 6;
% penalG = 3; nEig = 1; prSel = {['B','C','V'], [1.2,0.15]};
% ---------------------------- PRE. 1) MATERIAL AND CONTINUATION PARAMETERS
[E0,Emin,nu] = deal(1,1e-6,0.3);                                           % Young's moduli & Poisson's ratio
if prSel{1}(1) == 'V', volfrac = 1.0; else, volfrac = prSel{2}(end); end   % initialize volume fraction
% ----------------------------------------- PRE. 2) DISCRETIZATION FEATURES
Ly = nely/nelx*Lx;                                                         % recover Ly from aspect ratio
nEl = nelx*nely;                                                           % number of elements
elNrs = reshape(1:nEl,nely,nelx);                                          % element numbering
nodeNrs = int32(reshape(1:(1+nely)*(1+nelx),1+nely,1+nelx));               % node numbering (int32)
cMat = reshape(2*nodeNrs(1:end-1,1:end-1)+1,nEl,1)+int32([0,1,2*nely+[2,3,0,1],-2,-1]);% connectivity matrix
nDof = (1+nely)*(1+nelx)*2;                                                % total number of DOFs
% ---------------------------------------------- elemental stiffness matrix
c1 = [12;3;-6;-3;-6;-3;0;3;12;3;0;-3;-6;-3;-6;12;-3;0;-3;-6;3;12;3;...
    -6;3;-6;12;3;-6;-3;12;3;0;12;-3;12];
c2 = [-4;3;-2;9;2;-3;4;-9;-4;-9;4;-3;2;9;-2;-4;-3;4;9;2;3;-4;-9;-2;...
    3;2;-4;3;-2;9;-4;-9;4;-4;-3;-4];
Ke = 1/(1-nu^2)/24*(c1+nu.*c2);                                            % lower symmetric part of Ke
[sI,sII] = deal([]);
for j = 1:8      % build assembly indices for the lower symmetric part of K
    sI = cat(2,sI,j:8);
    sII = cat(2,sII, repmat(j,1,8-j+1));
end
[iK,jK] = deal(cMat(:,sI)',cMat(:,sII)');
Iar = sort([iK(:),jK(:)],2,'descend');                                     % indices for K assembly
if any(prSel{1}=='B') % >>>>>>>>>>>>>>>> PERFORM ONLY IF BUCKLING IS ACTIVE #B#
    Cmat0 = [1,nu,0;nu,1,0;0,0,(1-nu)/2]/(1-nu^2);                         % non-dimensional elasticity matrix
    xiG = sqrt(1/3)*[-1,1]; etaG = xiG; wxi = [1,1]; weta = wxi;           % Gauss nodes and weights
    xe = [-1,-1;1,-1;1,1;-1,1].*Lx/nelx/2;                                 % dimensions of the elements
    lMat = zeros(3, 4); lMat(1, 1) = 1; lMat(2, 4) = 1; lMat(3, 2:3) = 1;  % placement matrix
    dN = @(xi,zi) 0.25*[zi-1,1-zi,1+zi,-1-zi; xi-1,-1-xi,1+xi,1-xi];       % shape funct. logical derivatives
    B0 = @(gradN) lMat * kron(gradN,eye(2));                               % strain-displacement matrix
    [indM,~] = deal([1,3,5,7,16,18,20,27,29,34],[ 2,3,4,6,7,9 ]);      % auxiliary set of indices (1)
    [iG,jG] = deal(iK(indM,:),jK(indM,:));                                 % indexing of unique G coefficients
    IkG = sort([iG(:), jG(:)],2,'descend');                                % indexing G entries (lower half)
end % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< #B#
% ----------------------------- PRE. 3) LOADS, SUPPORTS AND PASSIVE DOMAINS
fixed = fixeddofs;                                                      % restrained DOFs (cantilever)
% [F(lcDof(1)),F(lcDof(end))] = deal(F(lcDof(1))/2,F(lcDof(end))/2);         % consistent load on end nodes
[pasS,pasV] = deal(elNrs(nely/2+[-9:10],end-9:end),[]);                    % define passive domains
[pasS,pasV] = deal([],[]);
% [pasS,pasV] = deal(elNrs(nely/2+[-1:2],end-1:end),[]);                    % define passive domains
free = setdiff(1:nDof, fixed);                                             % set of free DOFs
act = setdiff((1:nEl)',union(pasS(:),pasV(:)));                            % set of active design variables
% ------------------------- PRE. 4) PREPARE FILTER AND PROJECTION OPERATORS
if ftBC == 'N', bcF = 'symmetric'; else, bcF = 0; end                      % select filter BC
[dy,dx] = meshgrid(-ceil(rmin)+1:ceil(rmin)-1,-ceil(rmin)+1:ceil(rmin)-1);
h = max(0,rmin-sqrt(dx.^2+dy.^2));                                         % convolution kernel
% ------------------------ PRE. 5) ALLOCATE AND INITIALIZE OTHER PARAMETERS
U = zeros(nDof,1);   % " " of size nDofx1 & nDofxnEig
clear iK jK iG jG dx dy;     % initialize xPhys and free memory
% xPhys = x;
%% ________________________________________________ START OPTIMIZATION LOOP
% loop = loop+1;                                                           % update iteration counter
% --------------------------------- RL. 1) COMPUTE PHYSICAL DENSITY FIELD
% xTilde = imfilter(reshape(x,nely,nelx),h,bcF)./Hs;                       % compute filtered field
xPhys(act) = x(act);                                                % modify active elements only
xPhys=xPhys(:);
% -------------------------- RL. 2) SETUP AND SOLVE EQUILIBRIUM EQUATIONS
sK = (Emin+xPhys.^penalK*(E0-Emin));                                     % stiffness interpolation
sK = reshape(Ke(:)*sK',length(Ke)*nEl,1);
K = fsparse(Iar(:,1),Iar(:,2),sK,[nDof,nDof]);                           % assemble stiffness matrix
K = K+K'-diag(diag(K));                                                  % symmetrization of K
dK = decomposition(K(free,free),'chol','lower');                         % decompose K and store factor
U(free) = dK \ F(free);                                                  % solve equilibrium system
if any(prSel{1}=='B') % >>>>>>>>>>>>>> PERFORM ONLY IF BUCKLING IS ACTIVE #B#
    % ---------------------------------- RL. 3) BUILD STRESS STIFFNESS MATRIX
    sGP = (Cmat0*B0((dN(0,0)*xe)\dN(0,0))*U(cMat)')';                        % stresses at elements centroids
    sigma_x = sGP(:,1);sigma_y = sGP(:,2);tau_xy = sGP(:,3);
    % sigma_v = sqrt(sigma_x.^2 - sigma_x.*sigma_y + sigma_y.^2 + 3*tau_xy.^2);
    vonMisesStress = sqrt(     (sigma_x+sigma_y).^2 - 3*(sigma_x.*sigma_y-tau_xy.^2)       );
    Z = zeros(nEl,10);      % allocate array for compact storage of Ge coeff.
    for j = 1:length(xiG)                       % loop over quadrature points
        for k = 1:length(etaG)
            % ---------------------------- current integration point and weight
            xi = xiG(j); zi = etaG(k); w = wxi(j)*weta(k)*det(dN(xi,zi)*xe);
            % - reduced represenation of strain-displacement matrix (see paper)
            gradN = (dN(xi,zi)*xe)\dN(xi,zi);                                  % shape funct. physical derivatives
            a = gradN(1,:); b = gradN(2,:); B = zeros(3,10);
            l = [1,1;2,1;3,1;4,1;2,2;3,2;4,2;3,3;4,3;4,4];
            for jj = 1:10
                B(:,jj) = [a(l(jj,1))*a(l(jj,2)); ...
                    b(l(jj,1))*b(l(jj,2)); ...
                    b(l(jj,2))*a(l(jj,1))+b(l(jj,1))*a(l(jj,2))];
            end
            % ----------- current contribution to (unique ~= 0) elements of keG
            Z = Z+sGP*B*w;
        end
    end
    sG0 = E0*xPhys.^penalG;                                                  % stress interpolation
    sG = reshape((sG0.*Z)',10*nEl,1);
    G = fsparse(IkG(:,1)+1,IkG(:,2)+1,sG,[nDof,nDof])+...
        fsparse(IkG(:,1),  IkG(:,2),  sG,[nDof,nDof]);                    % assemble global G matrix
    G = G+G'-diag(diag(G));                                                  % symmetrization of G
    % ------------------------------ RL. 4) SOLVE BUCKLING EIGENVALUE PROBLEM
    matFun = @(x) dK\(G(free,free)*x);                                       % matrix action function
    opts.tol = 1e-3;
    [~,D] = eigs(matFun,length(free),nEig,'sa',opts);                      % compute eigenvalues
    [BLF,~] = sort(diag(-D),'descend');                                      % sorting of eigenvalues (mu=-D(i))
    BLF=1/BLF;
end % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
end




