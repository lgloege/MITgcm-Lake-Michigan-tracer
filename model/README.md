## Model
This directory contains all the code used to compile and run MITgcm-Michigan-Phosphorus.

- `source` = model source code (**~~do not modify these files~~**)
- `code` = modifications to source files
- `inputs` = binary input files for the model. A script to download the input files is provide. The script downloads the data from [here](https://google.com).
- `running` = configuration files used to run the model (plus initialization files)
- `build_MITgcm.bash` = Shell script to compile the model. This creates an executable that you will need to move to to the `running` directory.

## Compile
The following steps describe how to compile the model

1. Make sure path to `source` directory is set properly in `build_MITgcm.bash`
2, Make sure path to `code` directory is set properly `build_MITgcm.bash`
3. Set the path to your machine's build option file (i.e. optfile) in `build_MITgcm.bash`. MITgcm provides in common optfiles here `source/tools/build_options/`
4. `./build_MITgcm.bash` will run the build script and compile the model
5. This will create an executable called `mitgcmuv`. Move this execuatble to `running`
6. You are now ready to run the simulation!

## Running the model
This directory contains the data files used to run the model. `bathy_Lake_Michigan_1min.bin` is a binary bathymetry file.

1. Make sure you moved the `mitgcmuv` executable from the build directory to `running`.
2. Change the paths in the data files to correct forcing files stored in the `inputs` directory.
3. Use `run_1d_MITgcm_habanero.sh` to run the model. You may need to modify this, as it is currently setup to run on the Habanero cluster at Columbia University.

## Sources for the model forcing fields
Model input sources are provided below:
- Great Lakes bathymetry data is available [here](https://www.ngdc.noaa.gov/mgg/greatlakes/greatlakes.html)
- NARR atmospheric forcing fields are available [here](https://www.esrl.noaa.gov/psd/data/gridded/data.narr.html)
- Lake ice forcing is available [here](http://www.natice.noaa.gov/products/great_lakes.html).
- Tributary phosphorus fluxes were calculated from daily estimates of discharge and total phosphorus calculated using the [WRTDS method](http://onlinelibrary.wiley.com/doi/10.1111/j.1752-1688.2010.00482.x/abstract). These estimates were made by [Matthew Diebel](https://www.researchgate.net/profile/Matthew_Diebel) and are available in the `raw/wrtds` directory. The code used to calculate tributary phosphorus fluxes is in the `scripts` directory.

