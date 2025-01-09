% Initialize flag to ensure the pause message is displayed only once
once_flag = 0;

% Loop while the pause_ui condition is true
while pause_ui == 1
    % Display pause message only the first time through the loop
    if once_flag == 0
        disp('Program paused!');
        once_flag = 1;
    end
    
    % Check if continue_ui is set, then exit the loop
    if continue_ui == 1
        pause_ui = 0;       % Reset pause_ui
        continue_ui = 0;   % Reset continue_ui
        break;             % Exit the loop
    end
    
    % Wait for 1 second before checking conditions again
    pause(1);
end