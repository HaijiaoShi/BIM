% Define the file paths
filePathA = 'initial file\CLEAN_Results_Processing.xlsx';
filePathB = 'initial file\gene_data.xlsx';

% Read data from the Excel files
dataA = readtable(filePathA, 'Sheet', 'Single Highest Score');
dataB = readtable(filePathB, 'Sheet', 'Sheet1');

% Compare the second column of dataA with the first column of dataB and get indices
[~, idxA] = ismember(dataA{:, 2}, dataB{:, 1});

% Filter out non-matching entries
idxA(idxA == 0) = [];  % Remove zero indices which represent non-matches

% Prepare the combined data for export
combinedData = [];
for i = 1:length(idxA)
    if idxA(i) > 0  % Check for valid matches
        combinedRow = [table2cell(dataA(i, :)), table2cell(dataB(idxA(i), :))];
        combinedData = [combinedData; combinedRow];
    end
end

% Convert to table
combinedTable = cell2table(combinedData);

% Write the combined data to a new Excel file
newFilePath = 'process file\CombinedData.xlsx';
writetable(combinedTable, newFilePath, 'WriteVariableNames', true);




% Define file path
filePath = 'process file\CombinedData.xlsx';

% Read the Excel file
data = readtable(filePath);

% Initialize a new column for results
data.Result = repmat("", height(data), 1);

% Perform comparison and fill results
for i = 1:height(data)
    if fuzzyMatch(data{i, 3}, data{i, 13})
        data.Result(i) = "✓";  % Use checkmark symbol
    else
        data.Result(i) = "✗";  % Use cross symbol
    end
end

% Write the modified data back to Excel
writetable(data, filePath, 'WriteVariableNames', true);




% Define file paths
filePathC = 'process file\CombinedData.xlsx';
filePathP = 'initial file\p-thermo.xls';

% Read data from files
dataC = readtable(filePathC);
dataP = readtable(filePathP, 'Sheet', 'Reaction List');  % Ensure the correct sheet is used

% Filter rows where the 14th column is "✓"
filteredC = dataC(strcmp(dataC{:, 14}, '✓'), :);

% Read the 10th column data from p-thermo
pThermoData = dataP{:, 10};

% Initialize cell array to store split data
pThermoDataSplitted = {};

% Split data from pThermoData by semicolons
for i = 1:length(pThermoData)
    splitData = strsplit(strtrim(pThermoData{i}), ';');
    splitData = strtrim(splitData);  % Trim spaces from each element
    pThermoDataSplitted = [pThermoDataSplitted; splitData(:)];
end

% Initialize table to store results
results = table();

% Iterate over filtered data
for i = 1:height(filteredC)
    currentData = filteredC{i, 3};
    matchFound = false;
    
    % Check each p-thermo data entry for a match
    for j = 1:length(pThermoDataSplitted)
        if any(strcmp(strtrim(currentData), pThermoDataSplitted{j}))
            matchFound = true;
            break;
        end
    end
    
    % If no match was found, add the first four columns of filteredC to results
    if ~matchFound
        results = [results; filteredC(i, 1:4)];
    end
end

% Check if results table is empty and avoid writing if it is
if ~isempty(results)
    % Write to a new sheet in the Excel file
    writetable(results, 'process file\CombinedData.xlsx', 'Sheet', 'Added Reactions A', 'WriteVariableNames', false);
end








% Read data from dataset A
filePathA = 'process file\CombinedData.xlsx';
dataA = readtable(filePathA, 'Sheet', 'Sheet1');

% Remove rows where the 14th column is '✓'
rowsToDelete = strcmp(dataA{:, 14}, '✓');
dataA(rowsToDelete, :) = [];

% Check the size of dataset A
if isempty(dataA)
    error('All rows were deleted. The dataset is empty.');
end

% Remove rows where the 13th column is not empty
rowsToDelete = ~cellfun('isempty', dataA{:, 13});
dataA(rowsToDelete, :) = [];

% Check the size of dataset A
if isempty(dataA)
    error('All rows were deleted. The dataset is empty.');
end

% Convert the 4th column from cell to numeric type
numericCol4 = str2double(dataA{:, 4});

% Remove rows where the 4th column values are less than 0.9
rowsToDelete = numericCol4 < 0.9;
dataA(rowsToDelete, :) = [];

% Check the size of dataset A
if isempty(dataA)
    error('All rows were deleted. The dataset is empty.');
end

% Sort by the 4th column in descending order
[~, sortIdx] = sort(numericCol4(~rowsToDelete), 'descend');
dataA = dataA(sortIdx, :);

% Read data from p-thermo
filePathP = 'initial file\p-thermo.xls';
dataP = readtable(filePathP, 'Sheet', 'Reaction List');

% Get the 10th column data from p-thermo and split by semicolons
tenthColP = dataP{:, 10};
pThermoDataSplitted = tenthColP;
for j = 1:length(tenthColP)
    splitP = strsplit(strtrim(tenthColP{j}), ';');
    splitP = strtrim(splitP);  % Trim spaces from each element
    pThermoDataSplitted = [pThermoDataSplitted; splitP(:)];
end

% Initialize row deletion logic
rowsToDelete = false(height(dataA), 1);

% Iterate over dataset A
for i = 1:height(dataA)
    currentA = strtrim(dataA{i, 3});  % Get and trim value from the 3rd column
    
    % Check if currentA is fully matched in pThermoDataSplitted
    if any(strcmp(currentA, pThermoDataSplitted))
        rowsToDelete(i) = true;
    end
end

% Remove matching rows
dataA(rowsToDelete, :) = [];

% Check the size of dataset A
if isempty(dataA)
    error('All rows were deleted. The dataset is empty.');
end

% Write the final result to a new Excel file without headers
writetable(dataA, 'process file\Added Reactions B.xlsx', 'Sheet', 'Sheet1', 'WriteVariableNames', false);








% Read data from CombinedData.xlsx
filePath1 = 'process file\CombinedData.xlsx';
data1 = readtable(filePath1, 'Sheet', 'Added Reactions A');

% Read data from Added Reactions B.xlsx
filePath2 = 'process file\Added Reactions B.xlsx';
data2 = readtable(filePath2, 'Sheet', 'Sheet1');

% Extract the first three columns from each dataset
data1_threeCols = data1(:, 1:3);
data2_threeCols = data2(:, 1:3);

% Combine the two datasets
combinedData = [data1_threeCols; data2_threeCols];

% Write the combined data to a new Excel file
writetable(combinedData, 'process file\Added Reactions.xlsx', 'WriteVariableNames', false);







% Read data from Added Reactions.xlsx
filePathA = 'process file\Added Reactions.xlsx';
dataA = readtable(filePathA, 'Sheet', 'Sheet1');

% Read data from Reaction_database.xlsx
filePathB = 'initial file\Reaction_datebase.xlsx';
dataB = readtable(filePathB, 'Sheet', 'ec-r-name-rn-c');  % Use the correct sheet name

% Initialize results array
results = {};

% Search each entry in the third column of dataA within the second column of dataB
for i = 1:height(dataA)
    searchValue = dataA{i, 3};  % Get the current value from the third column of dataA

    % Find matches in the second column of dataB
    idx = find(strcmp(dataB{:, 2}, searchValue));

    % Process all matched items
    for j = 1:length(idx)
        currentIdx = idx(j);
        % Process third column content by removing 'rn:' prefix and adding 'prediction_' prefix
        processedThirdCol = strcat('prediction_', regexprep(dataB{currentIdx, 3}, '^rn:', ''));

        % Get contents of fourth and sixth columns
        fourthCol = dataB{currentIdx, 4};
        sixthCol = dataB{currentIdx, 6};

        % Get the second column content
        secondCol = dataB{currentIdx, 2};

        % Add the result to the results array
        results = [results; {processedThirdCol, fourthCol, sixthCol, secondCol}];
    end
end

% Convert results to table format
resultsTable = cell2table(results, 'VariableNames', {'FirstColumn', 'SecondColumn', 'ThirdColumn', 'FourthColumn'});

% Write results to a new Excel file
writetable(resultsTable, 'process file\Reaction Matching.xlsx', 'WriteVariableNames', false);







% Define file path
filePath = 'process file\Reaction Matching.xlsx';

% Read data
data = readtable(filePath);

% Remove duplicate rows
% 'rows' parameter ensures that duplicates are removed based on entire rows
dataUnique = unique(data, 'rows');

% Create an empty table
emptyTable = cell2table(cell(0, size(dataUnique, 2)), 'VariableNames', dataUnique.Properties.VariableNames);

% Use writetable to clear the existing content and write new data
% First write an empty table to clear the original content
writetable(emptyTable, filePath, 'WriteMode', 'overwrite', 'WriteVariableNames', true);

% Then write the deduplicated data
writetable(dataUnique, filePath, 'WriteMode', 'append', 'WriteVariableNames', true);







% Define file path
filePath = 'process file\Reaction Matching.xlsx';

% Read data
data = readtable(filePath);

% Iterate through each row and check if the second column contains '未找到'
for i = 1:height(data)
    if strcmp(data{i, 2}, '未找到')
        % Replace the second column's content with the first column's content
        data{i, 2} = data{i, 1};
    end
end

% Create an empty table to clear the original file content
emptyTable = cell2table(cell(0, size(data, 2)), 'VariableNames', data.Properties.VariableNames);

% Use writetable to clear the existing content and write new data
writetable(emptyTable, filePath, 'WriteMode', 'overwrite', 'WriteVariableNames', true);

% Write the modified data back to the Excel file
writetable(data, filePath, 'WriteMode', 'append', 'WriteVariableNames', true);







% Read the modified results.xlsx file
% Define file paths
reactionFilePath = 'process file\Reaction Matching.xlsx';
metabolitesFilePath = 'initial file\bigg_models_metabolites.xlsx';

% Read data
reactionsData = readtable(reactionFilePath);
metabolitesData = readtable(metabolitesFilePath);

% Get the third column data from reactionsData
reactions = reactionsData{:, 3};

% Initialize a new cell array to store modified reactions
modifiedReactions = cell(size(reactions));

% Process each reaction
for i = 1:length(reactions)
    % Split the reaction into components by spaces and + separators
    components = strsplit(reactions{i}, {' ', '+', '<=>', '<->', '->'});
    
    % Process each component in the reaction
    for j = 1:length(components)
        component = strtrim(components{j});  % Trim spaces from the component
        
        % Find matching rows in metabolitesData based on component
        matchIdx = find(contains(metabolitesData{:, 5}, component), 1);
        
        if ~isempty(matchIdx)
            % If a match is found, replace with content from the first column
            replacement = metabolitesData{matchIdx, 1}{1};
            
            % Apply compartment conversion rules
            replacement = ensureCompartment2(replacement);
            
            % Replace the current component
            components{j} = replacement;  % Use curly braces to index and modify cell array elements
        end
    end
    
    % Reassemble the reaction
    modifiedReactions{i} = strjoin(components, ' + ');
end

% Place modified reactions into the original table
reactionsData{:, 3} = modifiedReactions;

% Convert table data to cell array
dataCell = table2cell(reactionsData);

% Clear original content and write modified data
writetable(cell2table(cell(0, size(dataCell, 2)), 'VariableNames', reactionsData.Properties.VariableNames), reactionFilePath, 'WriteMode', 'overwrite');
writecell(dataCell, reactionFilePath);







% Ensure COBRA Toolbox is installed and loaded
initCobraToolbox(false);  % Initialize COBRA Toolbox

% Read the initial model
model = readCbModel('initial file\p-thermo.xml');

% Read reaction information
reactionInfo = readtable('process file\Reaction Matching.xlsx');

% Iterate through each reaction and add to the model
for i = 1:height(reactionInfo)
    % Get each reaction's information
    reactionID = reactionInfo{i, 1}{1};    % First column: Abbreviation
    reactionName = reactionInfo{i, 2}{1};  % Second column: Description
    reactionFormula = reactionInfo{i, 3}{1}; % Third column: Reaction
    reactionECNumber = reactionInfo{i, 4}{1}; % Fourth column: EC Number
    % Check if the reaction already exists and generate a new ID to avoid conflicts
    newReactionID = reactionID;
    suffix = 1;
    while ismember(newReactionID, model.rxns)
        suffix = suffix + 1;
        newReactionID = sprintf('%s_%d', reactionID, suffix);
    end

    % Parse the reaction formula
    [metaboliteList, stoichCoeffList] = parseReactionFormula(reactionFormula);

    % Ensure all metabolites have compartment labels
    metaboliteList = cellfun(@(x) ensureCompartment(x), metaboliteList, 'UniformOutput', false);

    % Use COBRA Toolbox's addReaction function to add the reaction with bounds
    model = addReaction(model, newReactionID, ...
                        'metaboliteList', metaboliteList, ...
                        'stoichCoeffList', stoichCoeffList, ...
                        'reactionName', reactionName, ...
                        'lowerBound', -1000, ...
                        'upperBound', 1000);

    % Manually set the EC number for the reaction
    model.rxnECNumbers{find(strcmp(model.rxns, newReactionID))} = reactionECNumber;
end

% Save the modified model as a MAT file
save('process file\modified_p-thermo.mat', 'model');











% Read the SBML model
model = readCbModel('process file\modified_p-thermo.mat');

% Read the metabolite database
metaboliteData = readtable('initial file\Metabolite Database.xlsx');

% Iterate through the metabolites in the model
for i = 1:length(model.mets)
    % Extract the current metabolite ID
    metID = model.mets{i};
    
    % Find corresponding information in the metabolite database
    idx = find(strcmp(metaboliteData{:, 1}, metID));
    
    % If a matching metabolite is found and information needs to be completed
    if ~isempty(idx)
        idx = idx(1); % Ensure only one match is used to avoid multiple values
        
        % Complete the chemical formula
        if isempty(model.metFormulas{i})
            model.metFormulas{i} = metaboliteData{idx, 3}{1};  % Ensure the retrieved value is a single string
        end
        
        % Complete the charge number
        if isnan(model.metCharges(i)) || model.metCharges(i) == 0
            model.metCharges(i) = metaboliteData{idx, 4};  % Ensure the retrieved value is a number
        end
        
        % Complete the KEGG ID
        if isempty(model.metKEGGID{i})
            model.metKEGGID{i} = metaboliteData{idx, 6}{1};  % Ensure the retrieved value is a single string
        end
    end
end

% Save the updated model
save('Output File\p-thermo_repair.mat', 'model');








