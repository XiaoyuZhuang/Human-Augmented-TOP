function [mmcfit] = extractAndFitmmc(binaryImage, EW)
    % Extract and fit Minimum Margin Convex (MMC) from a binary image
    % Inputs:
    %   binaryImage: Input binary image
    %   EW: Element width (for scaling)
    % Output:
    %   mmcfit: Fitted MMC parameters

    % Ensure binary image
    binaryImage(binaryImage > 0.5) = 1;
    binaryImage(binaryImage <= 0.5) = 0;

    % Extract skeleton
    skeleton = bwmorph(binaryImage, 'skel', Inf);

    % Detect key points
    endpoints = bwmorph(skeleton, 'endpoints', Inf);
    endpoints = bwmorph(endpoints, 'thicken', 1);
    branchpoints = bwmorph(skeleton, 'branchpoints');
    branchpoints = bwmorph(branchpoints, 'thicken', 1);
    bendPoints = detectBendPoints(skeleton);
    bendPoints = bwmorph(bendPoints, 'thicken', 1);

    % Remove key points from skeleton
    skeleton = skeleton - endpoints - branchpoints - bendPoints;
    skeleton(skeleton < 0) = 0;

    % Clean up skeleton
    skeleton = bwmorph(skeleton, 'diag');
    skeleton = bwmorph(skeleton, 'clean');

    % Fit rectangles to skeleton components
    rectFits = [];
    stats = regionprops('table', skeleton, 'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation');
    for i = 1:height(stats)
        centroid = stats.Centroid(i, :);
        majorAxisLength = stats.MajorAxisLength(i) + 0.02/EW;
        minorAxisLength = stats.MinorAxisLength(i) + 0.02/EW;
        orientation = stats.Orientation(i);
        rectFit = struct('Centroid', centroid, 'Dimensions', [majorAxisLength, minorAxisLength], 'Orientation', orientation);
        rectFits = [rectFits; rectFit];
    end

    % Convert rectangle fits to MMC parameters
    mmcfit = [];
    for i = 1:length(rectFits)
        theta = deg2rad(-rectFits(i).Orientation);
        xy00 = EW * [rectFits(i).Centroid(1), rectFits(i).Centroid(2), ...
                     rectFits(i).Dimensions(1)/2, rectFits(i).Dimensions(2)/2, ...
                     rectFits(i).Dimensions(2)/2, rectFits(i).Dimensions(2)/2, ...
                     sin(theta)/EW]';
        mmcfit = [mmcfit; xy00];
    end
end