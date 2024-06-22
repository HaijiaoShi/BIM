function model = constrainPool(model,non_measured,UB)
%Get compartment name for enzyme pool:
cd ..
parameters = getModelParameters;
cd limit_proteins
%Find compartment id:
compIndex = strcmpi(model.compNames,parameters.enzyme_comp);
comp      = model.comps{compIndex};

for i = 1:length(model.enzymes)
    if non_measured(i)
        rxnToAdd.rxns         = {['draw_prot_' model.enzymes{i}]};
        rxnToAdd.rxnNames     = rxnToAdd.rxns;
        rxnToAdd.mets         = {'prot_pool' ['prot_' model.enzymes{i}]};
        rxnToAdd.stoichCoeffs = [-model.MWs(i) 1];
        rxnToAdd.lb           = 0; % ub is taken from model default
        rxnToAdd.grRules      = model.enzGenes(i);
        model = addRxns(model,rxnToAdd,1,comp,true);
        model = removeReactions(model,{['prot_' model.enzymes{i} '_exchange']});
    end
end
%Finally, constraint enzyme pool by fixed value:
rxnToAdd.rxns         = {'prot_pool_exchange'};
rxnToAdd.rxnNames     = rxnToAdd.rxns;
rxnToAdd.mets         = {'prot_pool'};
rxnToAdd.stoichCoeffs = 1;
rxnToAdd.lb           = 0;
rxnToAdd.ub           = UB;
rxnToAdd.grRules      = {''};
model = addRxns(model,rxnToAdd);
end