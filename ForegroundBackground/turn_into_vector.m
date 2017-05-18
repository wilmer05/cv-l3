function X = turn_into_vector(image)

% turn_into_vector:  turn the data (e.g., a color image) into vector.
%
% Usage:
%   function X = turn_into_vector(image)

[rows cols colors]=size(image);
N=rows*cols;
image=double(image);

% vectorize image
X=zeros(colors,N);
for j=1:rows
    for i=1:cols
        ij=(j-1)*cols+i;
        X(1,ij)=image(j,i,1);
        X(2,ij)=image(j,i,2);
        X(3,ij)=image(j,i,3);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%