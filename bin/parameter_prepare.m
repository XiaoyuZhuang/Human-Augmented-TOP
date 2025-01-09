% Topology Optimization Initialization

% Design domain parameters
DW = 2; DH = 1; % Domain width and height
nelx = 100; nely = 50; % Number of elements in x and y directions
volfrac = 0.4; % Volume fraction
x_int = 0.5; y_int = 0.5; % Interval for component placement

% FEM mesh initialization
EW = DW / nelx; EH = DH / nely; % Element dimensions
[x, y] = meshgrid(EW * (0:nelx), EH * (0:nely));
LSgrid.x = x(:); LSgrid.y = y(:); % Node coordinates

% Material properties
h = 1; E = 1; nu = 0.3; % Thickness, Young's modulus, Poisson's ratio

% Component geometry initialization
x0 = x_int/2:x_int:DW; y0 = y_int/2:y_int:DH; % Component centers
xn = length(x0); yn = length(y0); % Number of component groups
x0 = kron(x0, ones(1, 2*yn));
y0 = repmat(kron(y0, ones(1,2)), 1, xn);
N = length(x0); % Total number of components

% Initial component parameters
ini_val = [0.38 0.04 0.06 0.04 0.7];
L = repmat(ini_val(1), 1, N); % Half length
t1 = repmat(ini_val(2), 1, N); t2 = repmat(ini_val(3), 1, N); t3 = repmat(ini_val(4), 1, N); % Half widths
st = repmat([ini_val(5) -ini_val(5)], 1, N/2); % Sine of inclined angle
variable = [x0; y0; L; t1; t2; t3; st];
% variable = []; % Uncomment for initial design without components

% MMA optimization parameters
xy00 = variable(:);
xval = xy00; xold1 = xy00; xold2 = xy00;
xmin = repmat([0; 0; 0.01; 0.01; 0.01; 0.03; -1.0], N, 1);
xmax = repmat([DW; DH; 2.0; 0.2; 0.2; 0.2; 1.0], N, 1);
% xmin = []; xmax = []; % Uncomment for initial design without components
low = xmin; upp = xmax;
m = 1; Var_num = 7; nn = Var_num * N; % Constraint and variable numbers
c = 1000 * ones(m, 1); d = zeros(m, 1); a0 = 1; a = zeros(m, 1);

% Mesh and element numbering
element_id = flip(reshape(1:nelx*nely, nely, nelx));
node_id = flip(reshape(1:(nelx+1)*(nely+1), nely+1, nelx+1));

% Boundary conditions
fixeddofs_y = 2 * node_id(end, end);
fixeddofs_x = 2 * node_id(1:end, 1) - 1;
fixeddofs = union(fixeddofs_y, fixeddofs_x);
alldofs = 1:2*(nely+1)*(nelx+1);
freedofs = setdiff(alldofs, fixeddofs);

% Load definition
loaddof = 2 * node_id(1, 1);
F = sparse(loaddof, 1, -1, 2*(nely+1)*(nelx+1), 1);

% Additional parameters
void_element = 0;
fixed_node = {-1, zeros((nely+1)*(nelx+1), 1) - 1}; % Fixed nodes for undesigned regions
rmin = 2; % Minimum radius
volfrac_init = repmat(volfrac, nely, nelx); % Initial volume fraction
maxiter = 50; penal = 3; ft = 1; % Iteration parameters

% FE analysis preparation
nodenrs = reshape(1:(1+nelx)*(1+nely), 1+nely, 1+nelx);
edofVec = reshape(2*nodenrs(1:end-1,1:end-1)-1, nelx*nely, 1);
edofMat = repmat(edofVec, 1, 8) + repmat([0 1 2*nely+[2 3 4 5] 2 3], nelx*nely, 1);
iK = kron(edofMat, ones(8,1))';
jK = kron(edofMat, ones(1,8))';
EleNodesID = edofMat(:, 2:2:8) ./ 2;
iEner = EleNodesID';
[KE] = BasicKe(E, nu, EW, EH, h); % Element stiffness matrix

% Heaviside function parameters
p = 6;
alpha = 1e-3; % Parameter alpha in the Heaviside function
epsilon = 4 * min(EW, EH); % Regularization parameter epsilon

% Initialize iteration variables
Phi = cell(N, 1);
Loop = 1;
change = 1;