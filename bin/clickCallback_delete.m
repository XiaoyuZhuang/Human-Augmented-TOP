function clickCallback_delete(src, event)
% Function to handle mouse clicks for selecting and potentially deleting components

global_declare; % Declare global variables
clickType = get(src, 'SelectionType');

if strcmp(clickType, 'normal') % Left mouse click
    axesHandle = get(src, 'CurrentAxes');
    point = get(axesHandle, 'CurrentPoint');
    
    % Determine the grid point based on the click location
    xq = round(point(1, 1) / (DW / (nelx + 1)));
    yq = round(point(1, 2) / (DH / (nely + 1)));
    
    hightlight; % Highlight the selected component
    
    for i = 1:N
        Phi_shaped = reshape(Phi{i}, nely + 1, nelx + 1);
        
        if Phi_shaped(yq, xq) > 0
            choice = questdlg('Do you want to delete?', 'Confirmation', 'Yes', 'No', 'No');
            
            if strcmp(choice, 'Yes')
                disp('Performing delete operation');
                
                % Update and delete the selected component
                xy00(Var_num * i - Var_num + 1:Var_num * i) = xy00(Var_num * i - Var_num + 1:Var_num * i) .* [1 1 0.3 0.9 0.9 0.9 1]';
                Phi{i} = tPhi(xy00(Var_num * i - Var_num + 1:Var_num * i), LSgrid.x, LSgrid.y, p);
                
                % Mark the node as void and update the parameters
                fixed_node{end + 1, 1} = -1;fixed = Phi{i};fixed_node{end, 2} = fixed(:);
                
                xy00(Var_num * i - Var_num + 1:Var_num * i) = 0.001;xy00_his{end + 1} = xy00;
                low(Var_num * i - Var_num + 1:Var_num * i) = 0.001;upp(Var_num * i - Var_num + 1:Var_num * i) = 0.001;
                xval(Var_num * i - Var_num + 1:Var_num * i) = 0.001;
                Phi{i} = tPhi(xy00(Var_num * i - Var_num + 1:Var_num * i), LSgrid.x, LSgrid.y, p);
                
                plot_result; % Update the plot with the modified components
                disp('Component deleted successfully!');
            else
                disp('Operation cancelled'); % User chose not to delete
            end
        end
    end
end
end