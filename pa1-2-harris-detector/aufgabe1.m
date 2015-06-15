% Vervollständigen Sie das folgende Skript und implementieren Sie die
% fehlenden Funktionen in den mitgelieferten Dateien
Image = imread('szene.jpg');
Gray = rgb_to_gray(Image);
tic;
Merkmale = harris_detektor(Gray, 'do_plot', true);
toc;