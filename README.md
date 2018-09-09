<h1 align="center"> MITgcm-Michigan-Phosphorus </h1>

<p align="center">
   <img height="400" src="https://github.com/lgloege/MITgcm-Michigan-Phosphorus/blob/master/results/figures_clean/Figure_1.png">
</p>


This repository contains a realistic three-dimensional hydrodynamic model of Lake Michigan
coupled to observed riverine phosphorus inputs. The purpose of the model is
to assess the redistribution of tributary-derived phosphorus in the lake.
Phosphorus is input to the lake from 11 tributaries that capture 70% of the annual load ([Rossmann 2006](https://www.epa.gov/sites/production/files/2015-08/documents/lmmbp-pcb-report.pdf)).

The quantitative framework is applicable to a wide range of pollutants and waterbodies and can help to guide coastal management efforts.

## model
This directory contains the MITgcm source files, modified code,
and data to run the MITgcm-Michigan-Phosphorus model.
The MITgcm source code is continuously being updated and is feely available from the developers. The most recent source code is available [here](https://github.com/MITgcm/MITgcm). The source code used in MITgcm-Michigan-Phosphorus is contained in `source`.

- `source` = model source code (**do not modify these files**)
- `code` = modifications to source files
- `inputs` = binary input files for the model. I provide a download script.
    #### ...or you can download the inputs from the links below
    * [inputs for 2007](https://figshare.com/articles/inputs_2007_zip/7064522)
    * [inputs for 2008](https://figshare.com/articles/inputs_2008_zip/7064768)
    * [inputs for 2009](https://figshare.com/articles/inputs_2009_zip/7064759)
    * [inputs for 2010](https://figshare.com/articles/inputs_2010_zip/7064765)
- `running` = configuration files used to run the model (plus initialization files)

## data
This directory contains model output and other data analyzed in this project. Raw model output is downloadable from figshare.
Some files are compressed to `tar.gz` file. `tar -xzf file_name.tar.gz` will unpack `tar.gz` files.
- `raw` = raw or unprocesed data.
    #### Daily output of surface phosphorus concentration for each river:
    * [Surface phosphorus output for 2007](https://figshare.com/articles/ptr_tave_0000315360_surf_nc/7040042)
    * [Surface phosphorus output for 2008](https://figshare.com/articles/ptr_tave_0000473040_surf_nc/7040048)
    * [Surface phosphorus output for 2009](https://figshare.com/articles/ptr_tave_0000631152_surf_nc/7040051)
    * [Surface phosphorus output for 2010](https://figshare.com/articles/ptr_tave_0000788832_surf_nc/7043378)

    #### Daily output of 3D phosphorus concentration for each river each file is 24Gb:
    * [3D phosphorus output for 2007](https://figshare.com/articles/ptr_tave_0000315360_glob_nc_tar_gz/7066520)
    * [3D phosphorus output for 2008](https://figshare.com/articles/ptr_tave_0000473040_glob_nc_tar_gz/7066538)
    * [3D phosphorus output for 2009](https://figshare.com/articles/ptr_tave_0000631152_glob_nc_tar_gz/7066553)
    * [3D phosphorus output for 2010](https://figshare.com/articles/ptr_tave_0000788832_glob_nc_tar_gz/7066571)

    #### Daily output of 3D temperature and current velocities each file is 14Gb:
    * [3D physical output for 2007](https://figshare.com/articles/tave_0000315360_glob_nc_tar_gz/7066583)
    * [3D physical output for 2008](https://figshare.com/articles/tave_0000473040_glob_nc_tar_gz/7066586)
    * [3D physical output for 2009](https://figshare.com/articles/tave_0000631152_glob_nc_tar_gz/7066589)
    * [3D physical output for 2010](https://figshare.com/articles/tave_0000788832_glob_nc_tar_gz/7066592)

- `raw/wrtds` = This directory contains daily histories of discharge (Q) in units of cubic meters per second and total phosphorus (TP) in units of mg/L for each river created using the weighted regressions on time, discharge, and season (WRTDS) method ([Hirsch et al., 2010](http://onlinelibrary.wiley.com/doi/10.1111/j.1752-1688.2010.00482.x/abstract)).
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
