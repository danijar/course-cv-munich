function [Fx,Fy]=sobel_xy(Image)
% In dieser Funktion soll das Sobel-Filter implementiert werden, welches
% ein Graustufenbild einliest und den Bildgradienten in x- sowie in
% y-Richtung zurückgibt.
    if size(Image, 3) ~= 1
        disp('The sobel filter can only operate on grayscale images.');
        return
    end
    Fx = conv2(Image, [-1  0  1; -2  0  2; -1  0  1] / 255);
    Fy = conv2(Image, [-1 -2 -1;  0  0  0;  1  2  1] / 255);
end
