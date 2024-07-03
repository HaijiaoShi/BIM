import re
# import os
import pandas as pd
f = open(r'C:\Users\wakaka\Desktop\keywords_1121_merge.txt', encoding="utf-8")
ftext = f.read()
f.close()

gene = ftext.replace('\n','')
gene = gene.split('  gene  ')[1:]

locus_tag_list_gene = []
locus_tag_list_CDS = []

re_locus_tag = re.compile(r'/locus_tag="(.*?)"')
locus_tag_list = [re_locus_tag.findall(i) for i in gene]
# locus_tag_list_gene = [i[0] for i in locus_tag_list]
# locus_tag_list_CDS = [i[-1] for i in locus_tag_list]

for i in locus_tag_list:
    if i == []:
        locus_tag_list_gene.append('')
        locus_tag_list_CDS.append('')
    else:
        locus_tag_list_gene.append(i[0])
        locus_tag_list_CDS.append(i[-1])

re_old_locus_tag = re.compile(r'/old_locus_tag="(.*?)"')
old_locus_tag_list = [re_old_locus_tag.findall(i) for i in gene]
old_locus_tag_list_gene = []
old_locus_tag_list_CDS = []
db_xref_list_gene=[]
db_xref_list_CDS = []
for i in old_locus_tag_list:
    if i == []:
        old_locus_tag_list_gene.append('')
        old_locus_tag_list_CDS.append('')
    else:
        old_locus_tag_list_gene.append(i[0])
        old_locus_tag_list_CDS.append(i[-1])

re_product = re.compile(r'/product="(.*?)"')
product_list = [re_product.findall(i) for i in gene]
product_list = [''.join(i) for i in product_list]
product_list = [re.sub(' +', '', i) for i in product_list]



re_db_xref = re.compile(r'/db_xref="(.*?)"')
db_xref_list = [re_db_xref.findall(i) for i in gene]
# db_xref_list_gene = [i[0] for i in db_xref_list]
# db_xref_list_CDS = [i[-1] for i in db_xref_list]

for i in db_xref_list:
    if i == []:
        db_xref_list_gene.append('')
        db_xref_list_CDS.append('')
    else:
        db_xref_list_gene.append(i[0])
        db_xref_list_CDS.append(i[-1])

re_translation = re.compile(r'/translation="(.*?)"')
translation_list = [re_translation.findall(i) for i in gene]
translation_list = [''.join(i) for i in translation_list]
translation_list = [i.replace(' ','') for i in translation_list]

ec_number = re.compile(r'/EC_number="(.*?)"')
ec_number_list = [ec_number.findall(i) for i in gene]
ec_number_list = [''.join(i) for i in ec_number_list]

df2 =pd.DataFrame({"locus_tag_list_gene": locus_tag_list_gene,"locus_tag_list_CDS":locus_tag_list_CDS,\
                   "old_locus_tag_list_gene": old_locus_tag_list_gene,"old_locus_tag_list_CDS":old_locus_tag_list_CDS,\
                   "product_list":product_list,\
                   "db_xref_list_gene":db_xref_list_gene,"db_xref_list_CDS":db_xref_list_CDS,\
                   "translation_list":translation_list,"EC number":ec_number_list})
df2.to_excel("C:\\Users\\wakaka\\Desktop\\gene.xlsx", sheet_name="sheet1",startcol=0, index=False)