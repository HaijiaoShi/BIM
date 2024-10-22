# Biological Intelligent Modeling Workshop (BIM) - Project Introduction and Usage Instructions

## Project Introduction

The Biological Intelligent Modeling Workshop (BIM) is an innovative de novo modeling strategy that integrates various artificial intelligence tools and algorithms to construct and optimize biological metabolic network models. To facilitate usage, the project divides functionality into separate modules, each responsible for different tasks, thereby enhancing the flexibility and efficiency of modeling.

## Main Functional Modules

### CLEAN Prediction Tool

**Function:** Predicts the complete genomic sequence of bacteria to discover potential functional proteins.  
**Main Code:** `CLEAN_Results_Processing.m`

### MetaPatchM Tool

**Function:** Automates the repair of genome-scale metabolic network models, optimizing the integrity of the models.  
**Main Code:** `MetaPatchM.m`

### TUST-Kcat Tool

**Function:** Predicts enzyme kinetic parameters, providing accurate enzymatic data.  
**Website:** [TUST-Kcat](https://www.mtc-lab.cn/tustkcat)

### EnzymeExtractor Program

**Function:** Automates the extraction of key information, such as translation sequences and gene names from GeneBank files of Bacillus thermoamylovorans, and converts it into FASTA files for prediction purposes.  
**Main Code:** `EnzymeExtractor.m`

### PKT Algorithm

**Function:** Assesses the impact of each reaction on biomass and product yields, considering carbon flux and the survival of cells after single reaction knockout simulations. By sequentially knocking out reactions in the model, it calculates changes in biomass and product yield compared to the wild type. The algorithm selects reactions with higher carbon flux for knockout and predicts high-yield knockout targets by combining each reaction's contribution to the target product (FBAsolution.w). This guides metabolic engineering strategies and strain optimization.  
**Description:** Carbon plays a central role in microbial growth and metabolism. The PKT algorithm evaluates each reaction's carbon load and specific flux, predicting optimization targets for high-yield products.

## Module Descriptions

### `CLEAN_Results_Processing.m`

This module processes the prediction results generated by the CLEAN tool. It analyzes the complete genomic sequence data to discover potential functional proteins in bacteria, providing foundational data for subsequent model repair and optimization.

### `MetaPatchM.m`

The MetaPatchM tool automates the repair of genome-scale metabolic network models. This module uses advanced algorithms to repair the model, ensuring its completeness and functionality, thus enhancing the accuracy and reliability of the metabolic network model.

### TUST-Kcat

The TUST-Kcat tool predicts enzyme kinetic parameters. Users can access [TUST-Kcat](https://www.mtc-lab.cn/tustkcat) for detailed information and to download the tool. This tool provides enzyme kinetic data for metabolic models, improving the model's accuracy. Due to future updates in TUST-Kcat versions, the data format may change. Please adjust the format to match the provided example format. If users upload their own data files, please ensure that the format is also standardized.

### `EnzymeExtractor.m`

This program automates the extraction of key information, such as translation sequences and gene names, from GeneBank files of Bacillus thermoamylovorans. It converts this information into FASTA file format for further prediction and analysis.

### PKT Algorithm

The PKT algorithm assesses the impact of reactions on biomass and target product yields. It selects reactions with higher carbon flux for knockout simulations and predicts high-yield knockout targets by analyzing changes in biomass and product yield compared to the wild type. This approach provides scientific guidance for metabolic engineering strategies and strain optimization.

## Contribution Guidelines

If you wish to contribute to the Biological Intelligent Modeling Workshop (BIM) project, please follow these steps:

1. Fork this repository.
2. Make and test modifications in your local environment.
3. Submit a pull request (PR) and provide a detailed description of your changes.

## License

This project uses the MIT License, allowing both personal and commercial use. Please refer to the `LICENSE` file for detailed information.
