% Define the file path
filePath = 'CLEAN_Results_Processing.xlsx';  % Path to the Excel file

% Explicitly set the data range to ensure all rows are read
opts = detectImportOptions(filePath, 'Sheet', 'CLEAN Results');
opts.DataRange = 'A1';  % Start reading from the first row

% Display all column names
disp(opts.VariableNames);

% Read the data table
data = readtable(filePath, opts);

% Ensure using the correct column name
columnName = opts.VariableNames{3};  % Ensure this is the correct name of the third column
disp(['Using column: ', columnName]);  % Display the column name being used

% Initialize two new columns to store the split data
splitColumn1 = cell(height(data), 1);
splitColumn2 = cell(height(data), 1);

% Iterate through each row of data, splitting based on '/'
for i = 1:height(data)
    currentData = data.(columnName){i};  % Use dynamic column name
    if ~isempty(currentData) && contains(currentData, '/')
        splitData = strsplit(currentData, '/');
        splitColumn1{i} = regexprep(splitData{1}, '^EC:', '');  % Remove 'EC:' prefix
        if numel(splitData) > 1
            splitColumn2{i} = splitData{2};
        else
            splitColumn2{i} = '';  % Ensure empty string if no second part
        end
    else
        splitColumn1{i} = regexprep(currentData, '^EC:', '');  % Remove 'EC:' prefix if no '/'
        splitColumn2{i} = '';
    end
end

% Create a new table including the first two columns and the split data
resultData = [data(:, 1:2), table(splitColumn1, splitColumn2, 'VariableNames', {'FirstPart', 'SecondPart'})];

% Write the result to a new Excel sheet
newSheetName = 'Single Highest Score';
writetable(resultData, filePath, 'Sheet', newSheetName, 'WriteVariableNames', false);
