% Written by: James J. Huang
% CSE_573 Homework 1
% Date: 09-13-2017

% Creating cell array with all filters
[filterBank] = createFilterBank();

% Saving all the filters into a folder
for i = 1:length(filterBank)
    imwrite(filterBank{i}, strcat('../filters/filter_', num2str(i), '.jpg'));
end

% Loading traintest.mat
load('../data/traintest.mat');

% Importing 70% of images into a cell
% Initializing size of cell
train_images = cell(floor(0.7 * length(train_imagenames)), 1);
for i = 1: floor(0.7 * length(train_imagenames))
    % Concatenate to obtain path
    train_images{i} = imread(strcat('../data/', train_imagenames{i}));
end

% Call extractFilterResponses on 1 test image
% Help is a 3D matrix, w/ the third dimension representing the color
% layers L, a, and b. Each layer is stored right after the other before
% the next filter.
% L1 a1 b1 L2 a2 b2 ...
testImg = 3;
[attempt] = extractFilterResponses(train_images{testImg}, filterBank);

% Creating a MxNx3x20 matrix 
% 4th Dimention is the concatenated layers of image (L, a, b)
testImageSize = size(train_images{testImg});
filteredMontage = zeros(testImageSize(1), testImageSize(2), 3, 20);
% Initialize j to keep track of position in 3rd dim in help
j = 1;
for i = 1: 20
    filteredMontage(:, :, :, i) = cat(3, attempt(:, :, j), attempt(:, :, j + 1), attempt(:, :, j + 2));
    j = j + 3;
end

% Creating a montage of the filtered images w/ defined size of
% montage display as 4 x 5
% montage(filteredMontage, 'Size', [4 5]);

imPaths = cell(length(test_imagenames), 1);
for i = 1:length(imPaths)
    imPaths{i} = strcat('../data/', test_imagenames{i});
end

[filterBank, dictionary] = getFilterBankAndDictionary(imPaths);
computeDictionary();
