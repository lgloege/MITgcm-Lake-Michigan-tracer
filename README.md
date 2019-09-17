<h1 align="center"> MITgcm-Lake-Michigan-tracer </h1>

<p align="center">
   <img height="400" src="https://github.com/lgloege/MITgcm-Lake-Michigan-tracer/blob/master/results/figures_jpg/Figure_1.jpg">
</p>

A three-dimensional hydrodynamic model of Lake Michigan that simulates the redistribution of a conservative tracer. 
The tracer follows the time history of phosphorus inputs. The tracer is input to the lake from 11 tributaries.

[doi.org/10.6084/m9.figshare.c.4222538](https://doi.org/10.6084/m9.figshare.c.4222538) contains a collection of input files to force MITgcm-Michigan-Phosphorus and output from the simulation.

If you have any questions or concerns, please either open up an issue in this repository or contact Luke directly (gloege at ldeo.columbia.edu).

## model
This directory contains the MITgcm source files, modified code,
and data to run the MITgcm-Lake-Michigan-tracer model.
The MITgcm source code is continuously being updated and is feely available from the developers. The most recent source code is available [here](https://github.com/MITgcm/MITgcm). The source code used in MITgcm-Lake-Michigan-tracer is contained in `source`.

- `source` = model source code (**do not modify these files**)
- `code` = modifications to source files
- `running` = configuration files used to run the model (plus initialization files)
- `setup_model_environment.sh` = downloads inputs and pickup files.

## data
This directory contains model output and other data analyzed in this project. Raw model output is downloadable from figshare.
Some files are compressed to `tar.gz` file. `tar -xzf file_name.tar.gz` will unpack `tar.gz` files.
- `raw` = raw or unprocesed data.

- `raw/wrtds` = This directory contains daily histories of discharge (Q) in units of cubic meters per second and total phosphorus (TP) in units of mg/L for each river created using the weighted regressions on time, discharge, and season (WRTDS) method ([Hirsch et al., 2010](http://onlinelibrary.wiley.com/doi/10.1111/j.1752-1688.2010.00482.x/abstract)).

- `raw/ES_2km_maps` = This directory contains ecosystem service shape-files on a 2km grid. These maps were created from the ecosystem service maps described in [Allan et al. 2015](https://esajournals.onlinelibrary.wiley.com/doi/full/10.1890/140328)

- `clean` = processed data. All processing scripts are in the `scripts` directory
- `shapefiles` = shapefiles used in this project

##  notebooks
This directory contains the python code used to generate figures.
For display purposes, some figures were fine-tuned using Adobe software.

##  results
This directory contains results from the project.

- `figures` = graphics produced from this project
- `papers` = manuscripts produced from this project
- `presentation` = talks or posters of presented work

## scripts
This directory contains scripts used to process model output
and scripts used to create model input files.

## doc
This directory contains documentation files.
