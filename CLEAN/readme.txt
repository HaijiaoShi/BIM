Introduction

This research incorporates an innovative machine learning algorithm, CLEAN, developed by Zhao Huimin's team, into BIM. The CLEAN algorithm, which has been detailed in the scientific article (DOI: 10.1126/science.adf2465), enhances predictive analytics capabilities within BIM frameworks.

Installation

The CLEAN tool is available on GitHub and can be installed from the following repository: CLEAN on GitHub: https://github.com/tttianhao/CLEAN.

Getting Started

To utilize CLEAN, follow these steps:

Activate the Virtual Environment:
Ensure that you have the required virtual environment set up. You can activate it using the following command:
conda activate clean

Navigate to the CLEAN Directory:
Change the directory to where CLEAN is installed on your system:
cd C:\Users\Documents\CLEAN\app

Run the CLEAN Inference Script:
To perform predictions on a genome file in FASTA format, use the CLEAN_infer_fasta.py script. Replace a with your specific FASTA file:
python CLEAN_infer_fasta.py --fasta_data a

This setup ensures you can efficiently apply the CLEAN algorithm for enhanced genomic predictions within the BIM environment. For more detailed usage and configuration, refer to the documentation provided in the GitHub repository.