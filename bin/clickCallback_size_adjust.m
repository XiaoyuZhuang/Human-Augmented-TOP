function clickCallback_size_adjust(src, event)
    global_declare;  % Declare global variables
    clickType = get(src, 'SelectionType');  % Get the type of mouse click
    
    if strcmp(clickType, 'normal')  % Check if the left mouse button was clicked
        axesHandle = get(src, 'CurrentAxes');  % Get the current axes
        point = get(axesHandle, 'CurrentPoint');  % Get the position of the mouse click
        
        % Calculate the grid position based on the click coordinates
        xq = round(point(1, 1) / (DW / (nelx + 1)));
        yq = round(point(1, 2) / (DH / (nely + 1)));
        
        hightlight;  % Highlight the selected point
        
        % Iterate through each structure element and adjust size if needed
        for i = 1:N
            Phi_shaped = reshape(Phi{i}, nely + 1, nelx + 1);
            if Phi_shaped(yq, xq) > 0
                % Prompt user to input new thickness
                answer = inputdlg({sprintf('Please enter the thickness: (Now: %.4f)', xval(Var_num * i - Var_num + 5))}, 'Input', [1 40], {'0.04'});
                numArray = str2num(answer{1});  % Convert input string to numerical array
                
                % Update corresponding variables with the new thickness
                xy00(Var_num * i - Var_num + 4 : Var_num * i - 1) = numArray;
                xy00_his{end + 1} = xy00;
                low(Var_num * i - Var_num + 4 : Var_num * i - 1) = numArray;
                xmin(Var_num * i - Var_num + 4 : Var_num * i - 1) = numArray;
                xval(Var_num * i - Var_num + 4 : Var_num * i - 1) = numArray;
                
                % Recalculate and update the Phi value
                Phi{i} = tPhi(xy00(Var_num * i - Var_num + 1 : Var_num * i), LSgrid.x, LSgrid.y, p);
                fixed_node{end + 1, 1} = 1;
                fixed_node{end, 2} = Phi{i};
                
                plot_result;  % Plot the updated result
                disp(['The size is constricted to ', num2str(numArray)]);
            end
        end
        
        plot_result;  % Final plot to ensure the latest status is displayed
    end
end