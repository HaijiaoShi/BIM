function Model = ToEnzymeModel(Model)
%Model=model_rev;
fprintf('Convert enzyme reaction...')

%data loading
[~,~,data] =  xlsread('kcat.xlsx','Sheet3');
Reaction   =  data(:,1);  %reaction name
ECs        =  data(:,2);
geneID     =  data(:,3);
Kcat       =  data(:,4);

[~,~,data1]     =  xlsread('kcat.xlsx','Sheet1');%Data deduplication
reaction        =  data1(:,1);
reactionNumber  =  unique(reaction);
ECNumber        =  data1(:,2);
%========================================================================%
for z = 1:length(ECNumber)
    if ~isempty(ECNumber{z})
        ECNumbers{z,1} = strsplit(ECNumber{z},';');
    else
        ECNumbers{z,1} = ECNumber{z};
    end
end
ECNumbers = flattenCell(ECNumbers);
%========================================================================%
res={};
% Model=model_rev
for i = 1:length(Model.rxnECNumbers)
    rxnID = Model.rxns{i};
    %%%Addition arm reaction
    for y = 1:length(reactionNumber)
        if isequal(rxnID, reactionNumber{y}) && ~isempty(ECNumbers{y,2})
            Model  = addArmReaction(Model,rxnID);
        end
    end
    %%%Add Kcat to the reaction
    x=0;
    for j=1:length(Reaction)
        if isequal(rxnID, Reaction{j})
            rxnIndex  = strcmp(Model.rxns,rxnID);
            x         = x+1;
            newID     = [rxnID '_No' num2str(x)];
            newName   = [Model.rxnNames{i} ' (No' num2str(x) ')'];
            kvalues   = Kcat{j};
            newMets   = ['prot_' geneID{j}];
            grRule    = Model.grRules{rxnIndex};
            Model     = addEnzymesToRxn(Model,kvalues,rxnID,newMets,{newID,newName},grRule);
            FBAsolution1 = optimizeCbModel(Model,'max');
            res=[res,FBAsolution1.f];
        end
    end
    if rem(i,100) == 0 || i == length(Model.rxnECNumbers)
        fprintf('.')
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
