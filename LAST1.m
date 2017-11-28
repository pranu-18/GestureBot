clc;clear;close all
ins=instrfindall();
imaqreset;
b=Bluetooth('HC-05',1);
fopen(b);
vid = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480');
vid.ReturnedColorSpace = 'rgb';
%preview(vid);
%pause(10);
%closepreview(vid);
for k=1:10000000
    i=step(vid);    
%     i=i*1.5;
    igray=rgb2gray(i);
    ir=i(:,:,2);
    ired= ir-igray;
    irw=im2bw(ired,10/255);
    %imshow(irw);
    irw=imclearborder(irw);
    irw=bwareaopen(irw,1500);
    irw1=imfill(irw,'holes');
    s=strel('disk',20);
    irw2=imclose(irw1,s);
    [~,L]=bwlabel(irw2);
        if L==1
        disp('Forward');
		fwrite(b,'f');
    elseif L==2
        disp('left');
		fwrite(b,'l');
    elseif L==3
        disp('Right');
		fwrite(b,'r');
    elseif L==4
        disp('Backward');
		fwrite(b,'b');
    else
        disp('stop');
		fwrite(b,'s');
    end
    imshow(flipdim(irw2,2));
    pause(0.01)
end
closepreview(vid);
delete(vid);
fclose(b);