function  Merkmale=harris_detektor(Image,varargin)
% In dieser Funktion soll der Harris-Detektor implementiert werden, der
% Merkmalspunkte aus dem Bild extrahiert
    % Check if we have a grayscale image
    if size(Image, 3) ~= 1
        disp('The Harris detector can only operate on grayscale images.');
        return
    end
    % Parse arguments
    args = inputParser;
    args.addOptional('segment_length', 3, @isnumeric);
    args.addOptional('k', 0.05, @isnumeric);
    args.addOptional('tau', 0.23, @isnumeric);
    args.addOptional('tile_size', 300, @isnumeric);
    args.addOptional('N', 10, @isnumeric);
    args.addOptional('min_dist', 100, @isnumeric);
    args.addOptional('do_plot', false, @islogical);
    parse(args, varargin{:});
    % Get gradients along both dimensions
    [Ix, Iy] = sobel_xy(Image);
    % Compute components of the Harris matrices
    Ix2 = Ix .^ 2;
    Iy2 = Iy .^ 2;
    Ixy = Ix .* Iy;
    % Apply gaussian filters to components
    kernel = gaussian(args.Results.segment_length - 2, 1);
    Ix2f = conv2(Ix2, kernel);
    Iy2f = conv2(Iy2, kernel);
    Ixyf = conv2(Ixy, kernel);
    % Compute edge and corner response measure
    Det = (Ix2f .* Iy2f) - (Ixyf .^ 2);
    Trace = Ix2f + Iy2f;
    Response = Det - args.Results.k * Trace .^ 2;
    % Normalize response measure and mask out corners below threshold
    min_response = min(Response(:));
    max_response = max(Response(:));
    Response = (Response - min_response) ./ (max_response - min_response);
    Corners = Response .* (Response > args.Results.tau);
    % Discard superfluous points in each tile
    Tiles = mat2tiles(Corners, args.Results.tile_size, args.Results.tile_size);
    Tiles = cellfun(@(Tile)keep_strongest_count(Tile, args.Results.N), Tiles, 'UniformOutput', false);
    Corners = cell2mat(Tiles);
    % Discard points near stronger points
    corner_indices = find(Corners > 0);
    radius = args.Results.min_dist;
    for i = 1:size(corner_indices)
        [index_y, index_x] = ind2sub(size(Corners), corner_indices(i));
        %  Find neighborhood
        from_x = max(index_x-radius, 1);
        from_y = max(index_y-radius, 1);
        to_x = min(index_x+radius, size(Corners, 2));
        to_y = min(index_y+radius, size(Corners, 1));
        neighbors = Corners(from_y:to_y, from_x:to_x);
        % Discard if there is a stronger neighbor
        largest = max(max(neighbors));
        if Corners(index_y, index_x) < largest
            Corners(index_y, index_x) = 0;
        end
    end
    % Return and plot points of features
	[MerkmaleX, MerkmaleY] = find(Corners);
    Merkmale = [MerkmaleX, MerkmaleY];
    if args.Results.do_plot
        imshow(Image, [0 255]);
        %imshow(Response, [0.2, 0.3]);
        hold on;
        plot(Merkmale(:, 2), Merkmale(:, 1), 'go');
    end
end

function kernel = gaussian(N, sigma)
    [x, y] = meshgrid(round(-N/2):round(N/2), round(-N/2):round(N/2));
    kernel = exp(-x.^2 / (2*sigma^2) - y.^2 / (2*sigma^2));
    kernel = kernel ./ sum(kernel(:));
end

function [Tile] = keep_strongest_count(Tile, N)
    values = unique(Tile(:));
    count = length(values) - N;
    if (count <= 1), return; end
    threshold = values(count);
    Tile(Tile < threshold) = 0;
end
