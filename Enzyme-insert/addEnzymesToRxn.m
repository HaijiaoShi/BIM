function model = addEnzymesToRxn(model,kvalues,rxn,newMets,newRxnName,protGenes)

if nargin < 5
    protGenes = '';
end

%Define all necessary parts for new (or changed) rxn:
rxnIndex = strcmp(model.rxns,rxn); 
metS     = model.mets(model.S(:,rxnIndex) < 0)';
metP     = model.mets(model.S(:,rxnIndex) > 0)';
coeffsS  = model.S(model.S(:,rxnIndex)<0,rxnIndex)';
coeffsP  = model.S(model.S(:,rxnIndex)>0,rxnIndex)';

%Find compartment id:
compIndex = strcmpi(model.compNames,'cytosol');
comp      = model.comps{compIndex};

%Include enzyme in reaction:
rxnToAdd.mets         = [metS,newMets,metP];
rxnToAdd.stoichCoeffs = [coeffsS,-kvalues.^-1,coeffsP];
%rxnToAdd.rxnECNumbers = EC;
if ismember(newRxnName{1},model.rxns)
    model = changeRxns(model,newRxnName(1),rxnToAdd,1,comp,true);
else    
    rxnToAdd.rxns     = newRxnName(1);
    rxnToAdd.rxnNames = newRxnName(2);
    rxnToAdd.lb       = model.lb(rxnIndex);
    rxnToAdd.ub       = model.ub(rxnIndex);
    rxnToAdd.obj      = model.c(rxnIndex);
    if ~isempty(protGenes)
        rxnToAdd.grRules = {protGenes};
    end
    if isfield(model,'subSystems')
        rxnToAdd.subSystems = model.subSystems(rxnIndex);
    end
    model = addRxns(model,rxnToAdd,1,comp,true);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
