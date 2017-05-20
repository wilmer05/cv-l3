function [] = ex23()
    centroids = zeros(2,3);
    centroids(:,1) = [0 1];
    centroids(:,2) = [1 1];
    centroids(:,3) = [0.5 0];
    
    [dim Kcentroids] = size(centroids);
    sigma =1 ;
    n = 1400;
    gm = sample_gm(n, sigma, centroids);
    gm2 = sample_gm2(n * Kcentroids, sigma, centroids);
    figure; plot(gm(1,:), gm(2,:), 'bo');%,gm2(1,:), gm2(2,:), 'rx');
    figure; plot(gm2(1,:), gm2(2,:), 'rx');
end