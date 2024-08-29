function eModel = convertToProteinModel(eModel)
fprintf('Convert Protein reaction...')
% eModel=Model
% Create additional fields in model:
eModel.enzymes   = cell(0,1);
eModel.enzGenes  = cell(0,1);
eModel.enzNames  = cell(0,1);
eModel.MWs       = zeros(0,1);
eModel.sequences = cell(0,1);
eModel.pathways  = cell(0,1);


[~,~,Data]=xlsread('MW.xlsx','Sheet3');%酶不重复
gene               = Data(:,1);
enzymes            = Data(:,2);
MWs                = Data(:,3);

compIndex = strcmpi(eModel.compNames,'cytosol');
comp      = eModel.comps{compIndex};
%----------------------------------------------------------------------
rxnToAdd.rxns         = {'prot_pool_exchange'};
rxnToAdd.rxnNames     = rxnToAdd.rxns;
rxnToAdd.mets         = {'prot_pool'};
rxnToAdd.stoichCoeffs = 1;
rxnToAdd.lb           = 0;
rxnToAdd.ub           = 940;
rxnToAdd.grRules      = {''};
eModel = addRxns(eModel,rxnToAdd,1,comp,true);
%----------------------------------------------------------------------
for i=1:length(enzymes)
    if ~ismember(gene{i},eModel.genes)
        geneToAdd.genes = {gene{i}};
       
        eModel = addGenesRaven(eModel,geneToAdd);
    end
    prot_name     = ['prot_' enzymes{i}];
    eModel.enzymes = [eModel.enzymes;enzymes{i}];
    eModel.MWs = MWs{i}/1000/0.5;
    rxnID = ['draw_prot_' enzymes{i}];
    rxnToAdd.rxns         = {rxnID};
    rxnToAdd.rxnNames     = {rxnID};
    rxnToAdd.mets         = {'prot_pool' prot_name};
    rxnToAdd.stoichCoeffs = [-eModel.MWs 1];
    rxnToAdd.lb           = 0;
    rxnToAdd.ub           = 1000;
    rxnToAdd.grRules      = {gene{i}};
    eModel = addRxns(eModel,rxnToAdd);

    if rem(i,50) == 0 || i == length(enzymes)
        fprintf('.')
    end
end

fprintf(' Done!\n')

end