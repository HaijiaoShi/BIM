
function geneDataExtractor()
   
    filepath = 'NZ_CP012712.txt';
    fileID = fopen(filepath, 'r', 'n', 'UTF-8');
    ftext = fread(fileID, '*char')';
    fclose(fileID);

    
    ftext = strrep(ftext, newline, '');
    genes = split(ftext, '  gene  ');
    genes(1) = []; 

  
    locus_tags_gene = [];
    locus_tags_CDS = [];
    old_locus_tags_gene = [];
    old_locus_tags_CDS = [];
    products = [];
    db_xrefs_gene = [];
    db_xrefs_CDS = [];
    translations = [];
    ec_numbers = [];


    for i = 1:length(genes)
        gene = genes{i};

        % Locus tags
        tags = regexp(gene, '/locus_tag="(.*?)"', 'match');
        if isempty(tags)
            locus_tags_gene{end+1} = '';
            locus_tags_CDS{end+1} = '';
        else
            locus_tags_gene{end+1} = regexprep(tags{1}, '^/locus_tag="(.*)"$', '$1');

            if length(tags) > 1
                locus_tags_CDS{end+1} = regexprep(tags{end}, '^/locus_tag="(.*)"$', '$1');
            else
                locus_tags_CDS{end+1} = locus_tags_gene{end};
            end
        end

        % Old locus tags
        old_tags = regexp(gene, '/old_locus_tag="(.*?)"', 'match');
        if isempty(old_tags)
            old_locus_tags_gene{end+1} = '';
            old_locus_tags_CDS{end+1} = '';
        else
            old_locus_tags_gene{end+1} = regexprep(old_tags{1}, '^/old_locus_tag="(.*)"$', '$1');
            if length(old_tags) > 1
                old_locus_tags_CDS{end+1} = regexprep(old_tags{end}, '^/old_locus_tag="(.*)"$', '$1');
            else
                old_locus_tags_CDS{end+1} = old_locus_tags_gene{end};
            end
        end

        % Products
        prod = regexp(gene, '/product="(.*?)"', 'match');
        
        products{end+1} = regexprep(join(prod), '^/product="(.*)"$', '$1');

        % DB xrefs
        xrefs = regexp(gene, '/db_xref="(.*?)"', 'match');
        if isempty(xrefs)
            db_xrefs_gene{end+1} = '';
            db_xrefs_CDS{end+1} = '';
        else
            db_xrefs_gene{end+1} = regexprep(xrefs{1}, '^/db_xref="(.*)"$', '$1');
            if length(xrefs) > 1
                db_xrefs_CDS{end+1} = regexprep(xrefs{end}, '^/db_xref="(.*)"$', '$1');
            else
                db_xrefs_CDS{end+1} = db_xrefs_gene{end};
            end
        end

        % Translations
        trans = regexp(gene, '/translation="(.*?)"', 'match');
        clean_trans = strrep(join(trans), '/translation="', '');
        clean_trans = strrep(clean_trans, '"', '');
        clean_trans = regexprep(clean_trans, '\s+', ''); 
        translations{end+1} = clean_trans;

        % EC numbers
        ec = regexp(gene, '/EC_number="(.*?)"', 'match');
        ec_numbers{end+1} = regexprep(join(ec), '^/EC_number="(.*)"$', '$1');
    end

    
    T = table(locus_tags_gene', locus_tags_CDS', old_locus_tags_gene', old_locus_tags_CDS', ...
              products', db_xrefs_gene', db_xrefs_CDS', translations', ec_numbers', ...
              'VariableNames', {'LocusTagGene', 'LocusTagCDS', 'OldLocusTagGene', 'OldLocusTagCDS', ...
                                'Product', 'DbXrefGene', 'DbXrefCDS', 'Translation', 'ECNumber'});
    writetable(T, 'gene_data.xlsx', 'Sheet', 1, 'WriteVariableNames', true);



opts = detectImportOptions('gene_data.xlsx');
opts.SelectedVariableNames = {'LocusTagGene', 'Translation'};
data = readtable('gene_data.xlsx', opts);


fastaFilename = 'gene_sequences.fasta';
fid = fopen(fastaFilename, 'wt'); 


for i = 1:height(data)
    if ~isempty(data.Translation{i}) 
        fprintf(fid, '>%s\n', data.LocusTagGene{i}); 
        fprintf(fid, '%s\n', data.Translation{i});   
    end
end


fclose(fid);

disp(['FASTA file created: ', fastaFilename]);