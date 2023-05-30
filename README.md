# A2 - Energy Efficiency Measures (EEMs) assessment

This pipeline uses a Measurement & Verification technique to assess Energy Efficiency Measures (EEMs) in buildings. This is an example of a pipeline based on BIGG-harmonised data that uses biggr to generate its results.

## Software requirements

This pipeline uses R and MLFlow to execute. You can install R from an official [CRAN repository](https://cloud.r-project.org/) and mlflow using pip. We strongly recommend the usage of a Python 3 virtual environment for the MLFlow installation.

Besides, several of the R code implemented in this pipeline extensively uses the R implementation of the BIGG AI Toolbox, a.k.a. [biggr](https://www.github.com/biggproject/biggr). In the link you will find further instructions to install the package. 

## Method

This pipeline consists on a sequence of data analytics tasks that perform multiple data preparation, transformation, modelling and storage processes, from the initial input data to the output data containing the results of the pipeline.

<img src="flowchart.png" alt="flowchart" width="700"/>

## Usage

### Input data

An example dataset is given (`source/example_data.zip`) containing a TTL file with the metadata of 20 tertiary buildings that had implemented an EEM, and several JSON files containing time series associated to those buildings. The format of this dataset is completely aligned with the BIGG Ontology v1.0. For custom implementations of this pipeline you must harmonise your data to the ontology and the pipeline could be executed.

The minimum data requirements needed for each building to execute the pipeline are: 

- Gross floor area of the building.
- One EEM implemented, or more, in the building.
- Hourly (or higher frequency) consumption time series.
- Defined energy tariffs and emissions related to the consumption time series.
- Hourly (or higher frequency) weather data time series.

### Output data

A set of TTL files containing the metadata of the results for each building and several JSON files containing the KPIs time series for all the buildings.
By default, stored in `source/output` once you execute the code. 

**Ìmportant note!** The results of the assessment are provided by EEM projects, which is an automatic grouping of single EEMs that are close in time. For instance, in a building where two EEMs were implemented during winter 2020 and another one was implemented in summer 2020, two projects will be considered (winter 2020 and summer 2020). At this stage, the algorithm cannot infer the energy savings produced by EEMs that are close in time (by default half a year). The threshold for the projects auto-generation are set in "EEMAssessmentConditions" fields of the `source/Settings.json`.

### Download the code

You only need to clone the repository in your local computer.

In a terminal (set your own repositories path):
```
cd <repositories_path>
git clone https://github.com/biggproject/A2-EEM-assessment.git
```

### Execute the pipeline

1. Start the MLFlow server from the virtual environment where you installed it. In a terminal (set your own virtual environment path):
```
cd <virtual_env_path>
source bin/activate
mlflow server --backend-store-uri sqlite:///backend.db --default-artifact-root default_artifact --host 127.0.0.1
```
2. Set the working directory to the `source` folder of this pipeline. In a terminal:
```
cd <repositories_path>
cd A2-EEM-assessment/source
```
3. Set the `config.json` file. Using a text editor edit each field of this file.
```
{
  "PYTHON3_BIN": "",                            # Python3 binary location in your filesystem		
  "MLFlow": {
    "ModelTrainingPeriodicity": "",             # Set the training periodicity in ISO 8601 periods format (yearly="P1M", monthly="P1Y", trimestral="P3M").
    "ForceModelTraining": false,                # Force the pipeline to train again the building models when executing the pipeline.
    "MLFLOW_BIN": "",                           # MLFlow binary location in your filesystem.
    "TrackingUri": "",                          # MLFlow tracking URI to visualise the models and check their performance.
    "StoreModels": true,                        # Define if the baseline models are stored in MLFlow.
    "IncludeArtifacts": true                    # MLFlow model results include the plots with mid-term results.
  },
  "InputDataDirectory": "example_data",         # The ZIP file name or folder containing the input data (do not include extension in case of ZIP file, the pipeline automatically decompress it).
  "OutputDataDirectory": "output"               # Name of the output folder where results will be stored.
}
```
3. Run the pipeline. In a terminal:
```
Rscript Main.R
```
4. Follow the logs of the execution and once finished, get the results from the output folder.