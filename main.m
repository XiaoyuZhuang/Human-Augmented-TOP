close all; clear; clc; % Clear workspace
addpath('.\bin'); % Add necessary paths
global_declare(); % Initialize global variables
parameter_prepare(); % Prepare environment
% Initial topology optimization
xPhys = top88(nelx, nely, volfrac, penal, rmin, ft, volfrac_init, maxiter, fixed_node, EleNodesID, F, fixeddofs, void_element);
% Perform Finite Element Analysis (FEA) for stress distribution and buckling load factor
[penalK, ft, ftBC, penalG, nEig, prSel] = deal(1, 2, 'N', 1, 1, {['B','C','V'], [1.2, 0.15]});
[BLF1, vonMisesStress] = FEA_BuckStress(xPhys, F, nelx, nely, penalK, rmin, ftBC, DW, penalG, nEig, prSel, fixeddofs);
plotResults(vonMisesStress, xPhys, nelx, nely, DW, DH, 5); % Plot initial results
displayResults(vonMisesStress, xPhys, BLF1); % Display initial results
% Convert simp to mmc component explanation
[mmcfit] = extractAndFitmmc(xPhys, EW); % Initial MMC extraction and fitting for first-stage transformation
prepare_for_mmcfit(); % Prepare for MMC fit
simp2mmc(); % Convert SIMP to MMC
% Main optimization loop with manual intervention
while true
    plotFixedNodes(fixed_node, nelx, nely, EleNodesID); % Plot operation influence area
    % Perform topology optimization
    xPhys = top88(nelx, nely, volfrac, penal, rmin, ft, xPhys, maxiter, fixed_node, EleNodesID, F, fixeddofs, void_element);
    % Perform FEA
    [BLF2, vonMisesStress] = FEA_BuckStress(xPhys, F, nelx, nely, penalK, rmin, ftBC, DW, penalG, nEig, prSel, fixeddofs);
    plotResults(vonMisesStress, xPhys, nelx, nely, DW, DH, 7); % Plot results
    displayResults(vonMisesStress, xPhys, BLF2); % Display results
    % Display optimization progress
    disp(['Improvement: ', num2str(BLF2 - BLF1)]);
    disp(['Relative improvement: ', num2str((BLF2 - BLF1) / BLF1)]);
    pause_ui = 1; % Pause for user input
    pause_continue_control();
end

% plotResults: Visualizes the stress distribution in the optimized structure
function plotResults(vonMisesStress, xPhys, nelx, nely, DW, DH, figNum)
    figure(figNum);
    vonMisesStress = reshape(vonMisesStress, nely, nelx); % Reshape stress vector to 2D matrix
    imagesc(flip(vonMisesStress .* xPhys)); % Plot stress distribution
    colorbar;axis off;pbaspect([DW DH 1]);drawnow;
end

% displayResults: Prints the maximum stress and eigenvalue (mu) to console
function displayResults(sigma_v, xPhys, mu)
    disp(['Max stress: ', num2str(max(max(sigma_v .* xPhys(:))))]); % Display max stress
    disp(['Mu: ', num2str(mu)]); % Display eigenvalue
end

% plotFixedNodes: Visualizes the fixed nodes in the design domain
function plotFixedNodes(fixed_node, nelx, nely, EleNodesID)
    figure(6);
    fixed_ele = zeros(nely, nelx); % Initialize fixed elements matrix
    for i = 1:size(fixed_node, 1)
        H_fixed_node = Heaviside(fixed_node{i,2}, 1e-3, nelx, nely, 0.5); % Apply Heaviside function
        x_fixed = reshape(sum(H_fixed_node(EleNodesID), 2) / 4, nely, nelx); % Calculate fixed elements density
        if fixed_node{i,1} < 0
            % If fixed_node{i,1} is less than 0, subtract x_fixed from fixed_ele (indicating removal)
            fixed_ele = fixed_ele - x_fixed;
        else
            % If fixed_node{i,1} is greater than or equal to 0, add x_fixed to fixed_ele (indicating addition)
            fixed_ele = fixed_ele + x_fixed;
        end
    end
    % Plot fixed node distribution
    imagesc(flip(fixed_ele)); 
    colormap("summer"); caxis([-1 1]); axis equal; axis tight; axis on;
    set(gca, 'XTick', [], 'YTick', [], 'LineWidth', 2); drawnow; 
end

% This MATLAB code is based on the theoretical details discussed in the following paper:  
% “Human-Augmented Topology Optimization Design with Multi-Framework Intervention”  
% Authors: Weisheng Zhang, Xiaoyu Zhuang, Xu Guo, Sung-Kie Youn  
% Published in Engineering with Computers  
% The code and user manual can be found at:  
% https://github.com/

% This MATLAB code was originally based on 88 lines of code written by:  
% E. Andreassen, A. Clausen, M. Schevenels, B.S. Lazarov, and O. Sigmund  
% Department of Solid Mechanics, Technical University of Denmark, DK-2800 Lyngby, Denmark.  
% The 88-line code was intended for educational purposes and is discussed in the paper:  
% “Efficient topology optimization in MATLAB using 88 lines of code”  
% Published in Structural Multidisciplinary Optimization, 2010.  
% The 88-line code and the PostScript version of the paper can be downloaded from:  
% http://www.topopt.dtu.dk

% The code also incorporates topology optimization using Moving Morphable Components (MMC),  
% developed by Guo Xu, Weisheng Zhang, and Jie Yuan,  
% from the Department of Engineering Mechanics and the State Key Laboratory of Structural Analysis for Industrial Equipment,  
% Dalian University of Technology.  
% For any suggestions and feedback, please contact guoxu@dlut.edu.cn

% Additionally, this code uses the MMA solver,  
% developed by Krister Svanberg in January 1999.  
% Contact email: krille@math.kth.se  
% Optimization and Systems Theory, KTH, SE-10044 Stockholm, Sweden.  
% The mmasub function performs one MMA iteration, aimed at solving a nonlinear programming problem.

% The code also references “Topology optimization with linearized buckling criteria in 250 lines of Matlab”,  
% written by Federico Ferrari (Johns Hopkins University, USA),  
% Ole Sigmund (Technical University of Denmark), and James K. Guest (Johns Hopkins University, USA).  
% Published by Springer-Verlag GmbH in 2021.  
% For more information, contact Federico Ferrari (fferrar3@jhu.edu).

% Disclaimer:  
% The authors reserve all rights but do not guarantee that the code is free of errors.  
% We do not accept any responsibility for any consequences arising from the use of this code.
