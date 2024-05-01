directory = 'pic';
imageFiles = dir(fullfile(directory));
imageFiles = imageFiles(3:end);
images = cell(1,numel(imageFiles)); 