function [result] = ex21()
    image = imread('../data/klimt1913.png');
    X = turn_into_vector(image);
    kclusters = 5;
    [label, model, llh] = emgm(X,kclusters);
    
    mu = model.mu;
    spread(X,label);
end