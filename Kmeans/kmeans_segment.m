function [segmented, centroids] = kmeans_segment(image, Kclusters)

    [a, b, c] = size(image);
    tmp = im2double(image);
    tmp = reshape(tmp, [a*b, 3]);
    [idx, centroids] = kmeans(tmp, Kclusters);
    segmented = zeros(a*b,3);
    for i=1 : a*b
        segmented(i, :) = centroids(idx(i), :);
    end
    
    segmented = im2uint8(segmented);
    segmented = reshape(segmented, [a,b,c]);
    centroids = im2uint8(centroids);
end