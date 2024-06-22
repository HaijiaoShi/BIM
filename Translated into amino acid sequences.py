from Bio import Seq
from Bio.Alphabet import IUPAC
from Bio.SeqRecord import SeqRecord
from Bio import SeqIO

# read the input sequence
dna = open("AC2005.txt").read().strip()
dna = Seq.Seq(dna, IUPAC.unambiguous_dna)

# transcribe and translate
mrna = dna.transcribe()
protein = mrna.translate()
print(protein)