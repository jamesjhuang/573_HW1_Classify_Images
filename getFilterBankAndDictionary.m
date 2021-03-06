function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

    filterBank  = createFilterBank();

    % TODO Implement your code here
    
    % Initialize cell to store filterResponses for each image
    filteredImgs = cell(length(imPaths), 1);
    
    % Run each image through extractFilterResponses and save output in cell
    image = cell(length(imPaths), 1);
    for j = 1:length(imPaths)
        image{j} = imread(imPaths{j});
        [filterResponses] = extractFilterResponses(image{j}, filterBank);
        filteredImgs{j} = filterResponses;
    end
    
    alpha = 200;
    
    % Initialize final alpha*T x 3*F matrix
    alphaFilterResp = ones(alpha*length(imPaths), 3* length(filterBank));
    
    % Indicate how many random pixels have been saved to matrix, so when
    % next image is being processed, the index starts at correct position
    pixelStored = 0;
    % Extract the 3*F values per random pixel of each image 
    for i = 1:floor(length(filteredImgs)/20)
        currentImg = filteredImgs{i};
        % Initialize random pixel positionsl, first find amount of
        % pixels in image using size
        imgSize = [size(currentImg, 1), size(currentImg, 2)];
        randPix = randperm(imgSize(1) * imgSize(2), alpha);
        [row, col] = ind2sub(imgSize, randPix);
        for j = 1:length(alpha)
            % Calculate the (row, column) of the pixel based on its number
            
            % Extract values from said pixel and store into matrix used for
            % k-means
            alphaFilterResp(j + pixelStored, :) = currentImg(row(j), col(j), :);
        end
        pixelStored = pixelStored + alpha;
    end
        
    % Calling kmeans
    [~, dictionary] = kmeans( alphaFilterResp, 100, 'EmptyAction', 'drop');
    
    % Tranpose dictionary
    dictionary = dictionary';
end
