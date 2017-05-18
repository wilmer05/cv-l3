function gm=sample_gm(n,sigma,centroids)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Draw samples from multiple Gaussian laws
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

gm=zeros(dim,n*Kcentroids);  %out = mw_change_flist(NULL,*n*c->size,*n*c->size,c->dim);

for c=1:Kcentroids
    for k=1:n
        for d=1:dim
            sample=NormalLaw();
            i=(c-1)*n+k;
            gm(d,i)=centroids(d,c) + sigma*sample;
        end
    end
end

function sample = NormalLaw()
a=rand(1,1);
b=rand(1,1);
sample=(sqrt(-2.*log(a))*cos(2.*pi*b));
