function [result] = segment()
    image = imread('../data/klimt1913.png');
    [a, b, c] = size(image);
    X = turn_into_vector(image);
    kclusters = 5;
    [label, model, llh] = emgm(X,kclusters);
    mu = model.mu;
    %spread(X,label);
    result = zeros(c, a*b);
    for i=1 : a*b
        result(:,i) = mu(:,label(i));
    end
    result = reshape(result', [b, a, c]);
    mini = min(min(min(result)));
    maxi = max(max(max(result))) - mini;
    
    result = result - mini;
    result = result ./ maxi;
    tmp = zeros(a,b,c);
    tmp(:,:,1) = result(:,:,1)';
    tmp(:,:,2) = result(:,:,2)';
    tmp(:,:,3) = result(:,:,3)';
    
    result = tmp;
end