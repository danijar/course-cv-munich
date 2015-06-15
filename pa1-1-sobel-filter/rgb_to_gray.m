function [Gray_image]=rgb_to_gray(Image)
% Diese Funktion soll ein RGB-Bild in ein Graustufenbild umwandeln. Falls
% das Bild bereits in Graustufen vorliegt, soll es zurückgegeben werden.
    % Check if we already have a grayscale image
    if size(Image, 3) == 1
        Gray_image = Image;
        return
    end
    % Gray_image = zeros(size(Image, 1), size(Image, 2));
    Gray_image = zeros(size(Image, 1), size(Image, 2));
    for i = 1:size(Image, 1)
        for j = 1:size(Image, 2)
            r = Image(i, j, 1);
            g = Image(i, j, 2);
            b = Image(i, j, 3);
            intensity = 0.299 * r + 0.587 * g + 0.144 * b;
            Gray_image(i, j) = uint8(intensity);
        end
    end
end
