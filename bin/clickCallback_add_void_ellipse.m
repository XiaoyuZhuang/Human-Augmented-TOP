function clickCallback_add_void_ellipse(src, event)
% Callback function to handle click events for drawing void ellipses

global_declare; % Declare global variables

% Create a new figure and axis for drawing
newFig = figure;
ax = axes(newFig);
plot_result; % Initial plot

while true
    % Wait for user to draw an ellipse
    h = drawellipse(ax, 'Color', 'red');
    wait(h);

    % Extract ellipse properties
    center = h.Center;
    semiAxes = h.SemiAxes;
    rotationAngle = mod(h.RotationAngle, 180);
    if rotationAngle > 0 && rotationAngle < 90
        rotationAngle = -rotationAngle;
    end
    theta = deg2rad(rotationAngle);
    x0 = center(1);
    y0 = center(2);
    L = 2 * semiAxes(1); % Ellipse major axis length
    t0 = semiAxes(2); % Ellipse minor axis length
    t = [t0, t0, t0];
    sin_theta = sin(theta);

    % Update void component parameters
    new_component = [x0, y0, L/2, t, sin_theta];
    N = N + 1;
    xy00(Var_num*N - Var_num + 1:Var_num*N) = new_component;
    xy00_his{end + 1} = xy00;
    xval = xy00;
    xold1 = xy00;
    xold2 = xy00;

    % Define variable limits
    xmin_temp = [0.001; 0.001; 0.001; 0.001; 0.001; 0.001; 1.0];
    xmax_temp = [DW; DH; 2.0; 0.2; 0.2; 0.2; 1.0];
    deform_coe = 0.3;
    low(Var_num*N - Var_num + 1:Var_num*N, 1) = new_component - deform_coe * xmax_temp';
    upp(Var_num*N - Var_num + 1:Var_num*N, 1) = new_component + deform_coe * xmax_temp';
    xmin(Var_num*N - Var_num + 1:Var_num*N, 1) = new_component - deform_coe * xmax_temp';
    xmax(Var_num*N - Var_num + 1:Var_num*N, 1) = new_component + deform_coe * xmax_temp';

    % Update the fixed node and plot results
    disp('Void ellipse added successfully!')
    Phi{N} = tPhi(xy00(Var_num*N - Var_num + 1:Var_num*N), LSgrid.x, LSgrid.y, 2);
    fixed_node{end + 1, 1} = -1;
    fixed_node{end, 2} = Phi{N};

    plot_result;

    % Ask user if they want to continue
    answer = questdlg('Would you like to draw another void ellipse?', 'Continue Drawing', 'Yes', 'No', 'Yes');
    if strcmp(answer, 'No')
        close(newFig);
        contourf(reshape(x, M), reshape(y, M), Phi_max, [0, 0]);
        axis equal;
        axis([0 DW 0 DH]);
        pause(1e-6);
        break;
    end
end