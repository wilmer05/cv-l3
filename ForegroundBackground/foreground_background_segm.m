fileId = fopen('../dataVideo/hall_qcif.yuv', 'r');
global model;
[mov, imgRgb ] = loadFileYuv('../dataVideo/hall_qcif.yuv' , 176 , 144 , 1:100) ;
ima=mov(66).cdata;
k=3;
frames = 100;
% visualizeVideo(mov, 1, 100);
pixFrames = framesByPixels(mov, frames);
segment(mov, pixFrames, k);

function visualizeVideo(mov, startIdx, endIdx)
    for i=startIdx:endIdx
        frame = patchFrame(mov(i).cdata, 52, 67, 2);
        image(uint8(frame));
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

function segment(mov, pixFrames, k)
global model;
    [rows, colums, colours] = size(mov(1).cdata());
    for i=52*67:rows*colums
        startRow=(i-1)*3+1;
        endRow=(i-1)*3+3; 
        [label, model, llh] = emgm(pixFrames(startRow:endRow,:), k);
        sigma1 = model.Sigma(:,:,1);
        s1 = norm([sigma1(1,1), sigma1(2,2), sigma1(3,3)]);
        sigma2 = model.Sigma(:,:,2);
        s2 = norm([sigma2(1,1), sigma2(2,2), sigma2(3,3)]);
        if size(model.Sigma, 3) > 2
            sigma3 = model.Sigma(:,:,3);
            s3 = norm([sigma3(1,1), sigma3(2,2), sigma3(3,3)]);
        else
            s3 = 999999999999999999;
        end
        
        t1 = -1; t2 = -1; t3 = -1; t4 = -1; t5 = -1; t6 = -1; t7 = -1;
        if s1 < s2 && s1 < s3
            t1 = s1;
            if s2<s3
                t2 = s1+s2;
            else
                t3 = s1 + s3;
            end  
         elseif s2 < s1 && s2 < s3
            if s1 < s3
                t4 = s2+s1;
            else
                t5 = s1 + s3;
            end
        elseif s3 < s1 && s3 < s2
            if s1 < s2
                t6 = s3 + s1
            else
                t7 = s1 + s3;
            end
        end    
    end
end

function [frame] = patchFrame(frame, x, y, sz)
    [rows, columns, c] = size(frame);
    if x-sz > 0 && x+sz <= rows && y-sz > 0 && y+sz <= columns
        for i=0:sz
            for j=0:sz
                frame(x+i,y+j, :) = [0 0 0];
                frame(x+i,y-j, :) = [0 0 0];
                frame(x-i,y+j, :) = [0 0 0];
                frame(x-i,y-j, :) = [0 0 0];
            end   
        end
        
    end
end