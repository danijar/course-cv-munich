% Vervollständigen Sie das folgende Skript und implementieren Sie die
% fehlenden Funktionen in den mitgelieferten Dateien

Image = imread('szene.jpg');
Gray = rgb_to_gray(Image);

[SobelX, SobelY] = sobel_xy(Gray);
subplot(1, 2, 1), imshow(SobelX, [-1 1]);
subplot(1, 2, 2), imshow(SobelY, [-1 1]);

%tic;
%Merkmale = harris_detektor(IGray,'do_plot',true);
%toc;