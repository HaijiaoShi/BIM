function irrevModel=Torev(model,rxns)

if nargin<2
    I=true(numel(model.rxns),1);
else
    rxns=convertCharArray(rxns);
    I=getIndexes(model,rxns,'rxns',true);
end

irrevModel=model;

revIndexesBool=model.rev~=0 & I;
revIndexes=find(revIndexesBool);
if any(revIndexesBool)
    irrevModel.S=[model.S,model.S(:,revIndexes)*-1];
    irrevModel.rev(revIndexes)=0;
    irrevModel.rev=[irrevModel.rev;zeros(numel(revIndexes),1)];
    
    %Get the limits for all normal and reversible rxns
    ubNormal=irrevModel.ub;
    ubNormal(revIndexes(ubNormal(revIndexes)<0))=0;
    lbNormal=irrevModel.lb;
    lbNormal(revIndexes(lbNormal(revIndexes)<0))=0;
    ubRev=irrevModel.lb(revIndexes)*-1;
    ubRev(ubRev<0)=0;
    lbRev=irrevModel.ub(revIndexes)*-1;
    lbRev(lbRev<0)=0;
    irrevModel.ub=[ubNormal;ubRev];
    irrevModel.lb=[lbNormal;lbRev];
    
    %The objective coefficents should be zero for the backwards reversible
    %reactions unless they were negative in the original. In that case they
    %should be positive for the backwards reversible and deleted from the
    %original
    irrevC=zeros(numel(revIndexes),1);
    
    if any(irrevModel.c(revIndexes)<0)
        originalC=irrevModel.c(revIndexes);
        irrevC(irrevModel.c(revIndexes)<0)=originalC(originalC<0)*-1;
        irrevModel.c(irrevModel.c<0 & revIndexesBool)=0;
    end
    irrevModel.c=[irrevModel.c;irrevC];
    
    irrevModel.rxns=[irrevModel.rxns;strcat(irrevModel.rxns(revIndexes),'_REV')];
    irrevModel.rxnNames=[irrevModel.rxnNames;strcat(irrevModel.rxnNames(revIndexes),' (reversible)')];
    
    if isfield(irrevModel,'grRules')
        irrevModel.grRules=[irrevModel.grRules;irrevModel.grRules(revIndexes,:)];
    end
    if isfield(irrevModel,'rxnMiriams')
        irrevModel.rxnMiriams=[irrevModel.rxnMiriams;irrevModel.rxnMiriams(revIndexes,:)];
    end
    if isfield(irrevModel,'rxnGeneMat')
        irrevModel.rxnGeneMat=[irrevModel.rxnGeneMat;irrevModel.rxnGeneMat(revIndexes,:)];
    end
    if isfield(irrevModel,'subSystems')
        irrevModel.subSystems=[irrevModel.subSystems;irrevModel.subSystems(revIndexes)];
    end
    if isfield(irrevModel,'eccodes')
        irrevModel.eccodes=[irrevModel.eccodes;irrevModel.eccodes(revIndexes)];
    end
    if isfield(irrevModel,'rxnComps')
        irrevModel.rxnComps=[irrevModel.rxnComps;irrevModel.rxnComps(revIndexes)];
    end
    if isfield(irrevModel,'rxnFrom')
        irrevModel.rxnFrom=[irrevModel.rxnFrom;irrevModel.rxnFrom(revIndexes)];
    end
    if isfield(irrevModel,'rxnScores')
        irrevModel.rxnScores=[irrevModel.rxnScores;irrevModel.rxnScores(revIndexes)];
    end
    if isfield(irrevModel,'rxnNotes')
        irrevModel.rxnNotes=[irrevModel.rxnNotes;irrevModel.rxnNotes(revIndexes)];
    end
    if isfield(irrevModel,'rxnConfidenceScores')
        irrevModel.rxnConfidenceScores=[irrevModel.rxnConfidenceScores;irrevModel.rxnConfidenceScores(revIndexes)];
    end
    if isfield(irrevModel,'rxnReferences')
        irrevModel.rxnReferences=[irrevModel.rxnReferences;irrevModel.rxnReferences(revIndexes)];
    end
    if isfield(irrevModel,'rxnKEGGID')
        irrevModel.rxnKEGGID=[irrevModel.rxnKEGGID;irrevModel.rxnKEGGID(revIndexes)];
    end
    if isfield(irrevModel,'rxnECNumbers')
        irrevModel.rxnECNumbers=[irrevModel.rxnECNumbers;irrevModel.rxnECNumbers(revIndexes)];
    end
end
end
