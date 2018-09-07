<h1 align="center"> MITgcm-Michigan-Phosphorus </h1>

<p align="center">
   <img height="400" src="https://github.com/lgloege/MITgcm-Michigan-Phosphorus/blob/master/results/figures_clean/Figure_1.png">
</p>


This repository contains a realistic three-dimensional hydrodynamic model of Lake Michigan
coupled to observed riverine phosphorus inputs. The purpose of the model is
to assess the redistribution of tributary-derived phosphorus in the lake.
Phosphorus is input to the lake from 11 tributaries that capture 70% of the annual load ([Rossmann 2006](https://figshare.com)).

The quantitative framework is applicable to a wide range of pollutants and waterbodies and can help to guide coastal management efforts.

## model
This directory contains the MITgcm source files, modified code,
and data to run the MITgcm-Michigan-Phosphorus model.
The MITgcm source code is continuously being updated and is feely available from the developers. The the most recent source code is available [here](https://github.com/MITgcm/MITgcm). The source code used in MITgcm-Michigan-Phosphorus is contained in `source`.

- `source` = model source code (**~do not modify these files~**)
- `code` = modifications to source files
- `inputs` = binary input files for the model
- `running` = configuration files used to run the model (plus initialization files)

## data
This directory contains model output and other data analyzed in this project
- `raw` = raw or unprocesed data. Daily averages of surface phosphorus concentration can be found here:
  * [ptr_tave.0000315360.surf.nc](https://figshare.com/articles/ptr_tave_0000315360_surf_nc/7040042) contains 2007 output
  * [ptr_tave.0000473040.surf.nc](https://figshare.com/articles/ptr_tave_0000473040_surf_nc/7040048) contains 2008 output
  * [ptr_tave.0000631152.surf.nc](https://figshare.com/articles/ptr_tave_0000631152_surf_nc/7040051) contains 2009 output
  * [ptr_tave.0000788832.surf.nc](https://figshare.com/articles/ptr_tave_0000788832_surf_nc/7043378) contains 2010 output
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

## References
Hirsch, R.M., et al.  (2010). Weighted regressions on time, discharge, and season (WRTDS), with an application to Chesapeake Bay river inputs. *JAWRA*, 46(5), 857-880, doi:[10.1111/j.1752-1688.2010.00482.x](http://onlinelibrary.wiley.com/doi/10.1111/j.1752-1688.2010.00482.x/abstract)

Rossmann, R. Results of the Lake Michigan Mass Balance Project: Polychlorinated Biphenyls Modeling Report. USEPA, Large Lakes Research Station, Grosse Ile, MI 621 (2006)
