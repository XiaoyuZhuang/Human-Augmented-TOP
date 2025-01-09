% Prepare initial design field
H_obj = element_to_node_density(xPhys, nely, nelx);
% Initialize control variables
press_ckey = 0;press_akey = 0;pause_ui = 0;
continue_ui = 0;flag_add = 1;
% Set maximum iterations and initialize loop counter
maxiter = 50;Loop = 1;
% Main optimization loop
while change > 0.0001 && Loop < maxiter
    % Calculate level set function
    get_Phi;
    plot_figure_with_menu;
    % Perform finite element analysis
    get_delta_phi;
    fea_analysis;
    % Calculate sensitivities and update design variables
    sensitivity_simp2mmc;
    update_x;
    plot_fandf0_formmc;
    Loop = Loop + 1;
    % Check if maximum iterations reached
    if Loop == maxiter,H1 = H;pause_ui = 1;end
    % Control for pausing and continuing the optimization
    pause_continue_control;
end

function H_obj = element_to_node_density(xPhys, nely, nelx)
    contrib = zeros(nely+1, nelx+1, 4);
    % Distribute element densities to corner nodes
    contrib(1:nely,   1:nelx,   1) = xPhys / 4;  % Top-left
    contrib(1:nely,   2:nelx+1, 2) = xPhys / 4;  % Top-right
    contrib(2:nely+1, 1:nelx,   3) = xPhys / 4;  % Bottom-left
    contrib(2:nely+1, 2:nelx+1, 4) = xPhys / 4;  % Bottom-right
    % Sum contributions to get node densities
    H_obj = sum(contrib, 3);
    H_obj = H_obj(:);
end