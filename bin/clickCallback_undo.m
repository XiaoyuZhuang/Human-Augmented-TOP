function clickCallback_undo(src, event)
    global_declare; % Declare global variables
    
    xy00_his(end) = []; % Remove the last element from history
    fixed_node(end, :) = []; % Remove the last row from fixed_node matrix
    
    xy00 = xy00_his{end}; % Get the latest value from history
    N = size(xy00, 1) / Var_num; % Calculate the number of nodes
    
    % Compute the shape functions for each node
    for i = 1:N
        Phi{i} = tPhi(xy00(Var_num*i - Var_num + 1:Var_num*i), LSgrid.x, LSgrid.y, p);
    end
    
    figure(2); % Switch to figure 2
    plot_result; % Plot the results
end
