# Scripts

This directory contains scripts used to generate MITgcm inputs or to pre-process model output.

### Process output
- `_process_data.ipynb` = script to process all the model output

### Threshold concentration
- `_analysis_estimate_threshold.ipynb` = script showing how the threshold concentraton was calculated

### Create MITgcm input files
- `_create_river_inputs.ipynb` = script used to create MITgcm river forcing files from raw WRTDS data product.

### Calculate flux from WRTDS output
- `calculate_flux.awk` = awk script to calculate phosphorus flux from discharge and concentration.
- `process_wrtds.sh` = shell utility to run `calculate_flux.awk`

