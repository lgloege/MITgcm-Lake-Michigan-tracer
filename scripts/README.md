# Scripts

This directory contains scripts used to generate MITgcm inputs or to pre-process model output.

### Create MITgcm inputs
- `create_wrtds_tracer_input.ipynb` = script used to create MITgcm input files from raw WRTDS data product.
- `export_binary.py` = python script to create binary files, courtesy of Ed Doddridge's [collection of python scripts](https://edoddridge.bitbucket.io/MITgcm_py/functions_8py_source.html) for processing MITgcm output.
- `get_model_grid.py` = helper script to load the MITgcm model grid
- `calculate_flux.awk` = awk script to calculate phosphorus flux from discharge and concentration.
- `process_wrtds.sh` = shell utility to run `calculate_flux.awk`

### Process output
- `_process_data.ipynb` = script to process all the model output
- `analysis_estimate_threshold.ipynb` = script showing how the threshold concentraton was calculated
