for i = 1:size(x_fixied, 1)
    if x_fixied{i, 1} < 0
        % Decrease xPhys and x by the fixed value, with a lower bound of 1e-6
        xPhys = max(xPhys - x_fixied{i, 2}, 1e-6);
        x = max(x - x_fixied{i, 2}, 1e-6);
    else
        % Increase xPhys and x by the fixed value, with an upper bound of 1
        xPhys = min(xPhys + x_fixied{i, 2}, 1);
        x = min(x + x_fixied{i, 2}, 1);
    end
end
if void_element ~= 0
    xPhys(void_element) = 0.001;
    x(void_element) = 0.001;
end
