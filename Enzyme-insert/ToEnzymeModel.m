function Model = ToEnzymeModel(Model)
% ToEnzymeModel
%   Converts a model with EC numbers to an enzyme-based model by adding
%   enzymes to reactions and incorporating kcat values.
%
%   Input: Model       a COBRA model structure with reaction information
%
%   Output: Model      an updated COBRA model structure with enzymes added

fprintf('Converting to enzyme reactions...\n')

% Load data from Excel files
[~,~,data] = xlsread('kcat.xlsx', 'Sheet3'); % Load enzyme data
Reaction   = data(:,1);  % Reaction names
ECs        = data(:,2);  % EC numbers
geneID     = data(:,3);  % Gene IDs
Kcat       = data(:,4);  % Kcat values

[~,~,data1] = xlsread('kcat.xlsx', 'Sheet1'); % Load reaction numbers
reaction    = data1(:,1); % Reaction names
reactionNumber = unique(reaction); % Unique reaction numbers
ECNumber    = data1(:,2); % EC numbers corresponding to reactions

%========================================================================%
% Split EC numbers if multiple are present in one cell
for z = 1:length(ECNumber)
    if ~isempty(ECNumber{z})
        ECNumbers{z,1} = strsplit(ECNumber{z}, ';');
    else
        ECNumbers{z,1} = ECNumber{z};
    end
end
ECNumbers = flattenCell(ECNumbers); % Flatten cell array for easier processing
%========================================================================%

res = {}; % Initialize result storage

% Iterate through each reaction in the model
for i = 1:length(Model.rxnECNumbers)
    rxnID = Model.rxns{i}; % Reaction ID
    % Add arm reaction if applicable
    for y = 1:length(reactionNumber)
        if isequal(rxnID, reactionNumber{y}) && ~isempty(ECNumbers{y,2})
            Model = addArmReaction(Model, rxnID);
        end
    end
    % Add kcat values to reactions
    x = 0;
    for j = 1:length(Reaction)
        if isequal(rxnID, Reaction{j})
            rxnIndex = strcmp(Model.rxns, rxnID);
            x = x + 1;
            newID = [rxnID '_No' num2str(x)];
            newName = [Model.rxnNames{i} ' (No' num2str(x) ')'];
            kvalues = Kcat{j}; % Kcat values
            newMets = ['prot_' geneID{j}]; % New metabolites
            grRule = Model.grRules{rxnIndex}; % Gene-reaction rule
            Model = addEnzymesToRxn(Model, kvalues, rxnID, newMets, {newID, newName}, grRule);
            FBAsolution1 = optimizeCbModel(Model, 'max'); % Optimize the model
            res = [res, FBAsolution1.f]; % Store the objective value
        end
    end
    if rem(i, 100) == 0 || i == length(Model.rxnECNumbers)
        fprintf('.')
    end
end

% Remove reactions that were processed
for t = 1:length(reactionNumber)
    Model = removeReactions(Model, reactionNumber{t});
end

fprintf(' Done!\n')
end
