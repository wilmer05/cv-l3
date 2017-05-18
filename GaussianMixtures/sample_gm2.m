function gm=sample_gm2(n,sigma,centroids)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Draw samples from a Gaussian Mixture
%
%   Input:
%          n: number of samples per centroid (e.g., 100)
%          sigma: standart deviation (e.g., 1)
%          centroids: centroids, any number 
%   Output:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dim Kcentroids]=size(centroids); %Kcentroids

% Initialize random seed :
% srand48( (long int) time (NULL) );

gm=zeros(dim,n);  %out = mw_change_flist(NULL,*n*c->size,*n*c->size,c->dim);

for k=1:n
    a=rand(1,1);
    c=round(a*Kcentroids);
    if (c>Kcentroids) 
        c=Kcentroids;
    end
    if (c<1)
        c=1;
    end
    for d=1:dim
        sample=NormalLaw();
        gm(d,k)=centroids(d,c) + sigma*sample;
    end
end

function sample = NormalLaw()
a=rand(1,1);
b=rand(1,1);
sample=(sqrt(-2.*log(a))*cos(2.*pi*b));
