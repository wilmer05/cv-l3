fileId = fopen('../dataVideo/hall_qcif.yuv', 'r');
global model;

[mov, imgRgb ] = loadFileYuv('../dataVideo/hall_qcif.yuv' , 176 , 144 , 1:100) ;
% [mov, imgRgb ] = loadFileYuv('../dataVideo/foreman_qcif.yuv' , 176 , 144 , 1:100) ;

k=3;
frames = 100;
pixels = getPixelsOfInterest(mov(1).cdata, 52, 67, 2);
% pixels = getPixelsOfInterest(mov(1).cdata, 100,120, 2);

pixFrames = framesByPixels(mov, frames);
mov = segment(mov, pixFrames, pixels, k);
visualizeVideo(mov, 1, 100);

function visualizeVideo(mov, startIdx, endIdx)
    for i=startIdx:endIdx
        image(uint8(mov(i).cdata));
        pause(0.1);
    end
end

function [pixFrames] = framesByPixels(mov, frames)
    pixFrames=zeros(prod(size(mov(1).cdata())),frames);
    for t=1:frames
        frameVector = turn_into_vector(mov(t).cdata);
        for p=1:size(frameVector,2)
            startRow=(p-1)*3+1;
            endRow=(p-1)*3+3; 
            pixFrames(startRow:endRow,t) = frameVector(:,p);
        end    
    end   
end

function [mov] = segment(mov, pixFrames, pixels, k)
    global model;
    threshold = 0.80;
    [rows, colums, colours] = size(mov(1).cdata());
%     pixels=[52,67];
    for idx=1:size(pixels, 1)
        x = pixels(idx,1);
        y = pixels(idx,2);
        i=(x-1)*176+y;
        startRow=(i-1)*3+1;
        endRow=(i-1)*3+3; 
        weights = zeros(1, 3);
        
        [label, model, llh] = emgm(pixFrames(startRow:endRow,:), k);
        
      
%         First faussian
        sigma1Matrix = model.Sigma(:,:,1);
        sigma1 = (sigma1Matrix(1,1) + sigma1Matrix(2,2) + sigma1Matrix(3,3))/3;
        weights(1) = model.weight(1)/sigma1;
        
%         Second gaussian
        sigma2Matrix = model.Sigma(:,:,2);
        sigma2 = (sigma2Matrix(1,1) + sigma2Matrix(2,2) + sigma2Matrix(3,3))/2;
        weights(2) = model.weight(2)/sigma2;
        
%         Third gaussian
        if size(model.Sigma, 3) > 2
            sigma3Matrix = model.Sigma(:,:,3);
            simga3 = sigma3Matrix(1,1) + sigma3Matrix(2,2) + sigma3Matrix(3,3);
            weights(3) = model.weight(3)/simga3;
        end
        
        weights_sorted = sort(weights,'descend');
        
        background = zeros(3,1);
        sum = model.weight(find(weights==weights_sorted(1)));
        background(1) = find(weights==weights_sorted(1));
        if sum < threshold
            sum = sum + model.weight(find(weights==weights_sorted(2)));
            background(2) = find(weights==weights_sorted(2));
        elseif sum < threshold
            background(3) = find(weights==weights_sorted(3));
        end
    
        for t=1:100
            if size(find(background==label(t)),1)==0
%                 Foreground White
                mov(t).cdata(x,y,:) = [255 255 255];
            else
%                 Backgroud Black
                mov(t).cdata(x,y,:) = [0 0 0];
            end
        end
    end    
end

function [pixels] = getPixelsOfInterest(frame, x, y, sz)
    [rows, columns, c] = size(frame);
    pixels =[];
    if x-sz > 0 && x+sz <= rows && y-sz > 0 && y+sz <= columns
        for i=x-sz:x+sz
            for j=y-sz:y+sz
               frame(i,j, :) = [0 0 0];
               pixels = cat(1,pixels,[i,j]);
            end   
        end
        
    end
end

