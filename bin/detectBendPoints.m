function bendPoints = detectBendPoints(skeleton)
    % Assume the skeleton is a binary image that has already been thinned
    % Initialize the bend points image (all set to 0)
    bendPoints = zeros(size(skeleton));

    % Get the coordinates of the skeleton pixels
    [row, col] = find(skeleton);
    points = [row, col];

    % Check each point
    for i = 2:length(points)-1
        % Get three consecutive points
        p1 = points(i-1, :);
        p2 = points(i, :);  % Current point
        p3 = points(i+1, :);

        % Calculate direction vectors
        v1 = p2 - p1;
        v2 = p3 - p2;
        
        % Calculate the angle between the two vectors (simplified calculation, distance not considered)
        angle = acosd(dot(v1, v2) / (norm(v1) * norm(v2)));

        % Set an angle threshold to determine what constitutes a bend point, here assuming > 170 or < 80 degrees are not considered bend points
        if angle < 170 && angle > 80
            bendPoints(p2(1), p2(2)) = 1;
        end
    end
    
    % More complex analysis, such as curvature-based calculations, can be added here
    
end