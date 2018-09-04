# Introduction
Code used in assess phosphorus redistribution in Lake Michigan

- `source` = directory with model source code (do not modifity this)
- `inputs` = the inputs used to force the model in different provinces (All inputs are available upon request)
- `code` = modified source code is here
- `running` = directory where you run the compiled model
- `build_MITgcm.bash` = script used to build and compile the model

# Compile
Set the paths to model source code, modified code, and optifle in  `build_MITgcm.bash`

Then compile the model with `./build_MITgcm.bash`

# Run model
This directory contains the data files used to run the model. bathy_Lake_Michigan_1min.bin is a binary bathymetry file.

Due to to size constraints, forcing files are not uploaded. Serious requests can be directed
to Luke Gloege (gloege at ldeo.columbia.edu)

- NARR atmospheric forcing fields are available [here](https://www.esrl.noaa.gov/psd/data/gridded/data.narr.html)
- Lake ice forcing is available [here](http://www.natice.noaa.gov/products/great_lakes.html).

In the data files, change the paths to correct forcing files in `inputs`.

Then use `run_1d_MITgcm_habanero.sh` to run the model. Make sure you moved the `mitgcmuv` executable
from the build directory.

This is currently setup to use the Habanero cluster at Columbia University.

