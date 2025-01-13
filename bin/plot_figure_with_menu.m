if mod(Loop,10)==1||Loop>maxiter-5
    % Plot contour
    f = figure(2);contourf(reshape(x, M), reshape(y, M), Phi_max, [0, 0]);hold on;
    colors = lines(N);numColors = length(colors);
    % Loop through and plot each contour with specified line properties
    for i = 1:N
        colorIndex = mod(i - 1, numColors) + 1; % Calculate color index
        contour(reshape(x, M), reshape(y, M), reshape(Phi{i}, size(Phi_max)), [0, 0], ...
            'LineWidth', 2, 'LineColor', colors(colorIndex, :));
    end
    hold off;
    % Create a context menu for interactive options
    cmenu = uicontextmenu(f);
    uimenu(cmenu, 'Text', 'Pause', 'MenuSelectedFcn', @(src, event) pause_button);
    uimenu(cmenu, 'Text', 'Continue', 'MenuSelectedFcn', @(src, event) continue_button);
    uimenu(cmenu, 'Text', 'Delete components', 'MenuSelectedFcn', @(src, event) set(gcf, 'WindowButtonDownFcn', @clickCallback_delete));
    uimenu(cmenu, 'Text', 'Add components', 'MenuSelectedFcn', @(src, event) clickCallback_add);
    uimenu(cmenu, 'Text', 'Add voids', 'MenuSelectedFcn', @(src, event) clickCallback_add_void);
    uimenu(cmenu, 'Text', 'Add ellipse components', 'MenuSelectedFcn', @(src, event) clickCallback_add_ellipse);
    uimenu(cmenu, 'Text', 'Add ellipse voids', 'MenuSelectedFcn', @(src, event) clickCallback_add_void_ellipse);
    uimenu(cmenu, 'Text', 'Adjust size', 'MenuSelectedFcn', @(src, event) set(gcf, 'WindowButtonDownFcn', @clickCallback_size_adjust));
    uimenu(cmenu, 'Text', 'Undo', 'MenuSelectedFcn', @(src, event) clickCallback_undo);
    f.ContextMenu = cmenu;
    % Update figure
    axis equal;axis([0 DW 0 DH]);colormap("default");set(gca, 'XTick', [], 'YTick', [], 'LineWidth', 2);drawnow; 
end