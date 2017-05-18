function [] = ex4()
    centroids = zeros(2,3);
    centroids(:,1) = [0 2];
    centroids(:,2) = [2 2];
    centroids(:,3) = [2 0];
    [dim Kcentroids] = size(centroids);
    sigma = 0.5;
    n = 1000;
    gm2 = sample_gm2(Kcentroids * n, sigma, centroids);
    figure; plot(gm2(1,:), gm2(2, :), 'bo');
    
    cd ../EM_GMM
    kclusters = 3;
    [label2, model, llh] = emgm(gm2, kclusters);
    spread(gm2, label2);
    
end