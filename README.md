# MITgcm-Michigan-Phosphorus

<p align="center">
 <!--  <img height="300" src="https://github.com/lgloege/test_repo/blob/master/results/figures/Figure_1.png">
    -->
</p>

This directory contains a realistic three-dimensional hydrodynamic model of Lake Michigan
coupled to observed riverine phosphorus inputs to assess the redistribution of
tributary-derived phosphorus in the lake. In our model, phosphorus is input to the lake
from 11 tributaries that capture 70% of the annual load.

The quantitative framework developed here is applicable to a wide range of pollutants and waterbodies and can help to guide coastal management efforts.

## model
This directory contains the MITgcm source files, modified code,
and data to run the MITgcm-Michigan-Phosphorus model.
The MITgcm source code is continuously being updated and is feely available from the developers:
[MITgcm source code](http://mitgcm.org/public/source_code.html).

- `source` = model source code (do not modify these files)
- `code` = directory with modified source code files
- `running` = data files used to run the model (plus initialization files)

Serious requests for the input files can be directed to Luke Gloege (gloege at ldeo.columbia.edu)

## data
This directory contains model output and other data analyzed in this project
- `raw` = raw or unprocesed data. Daily averages of surface phosphorus concentration can be found [here](https://figshare.com/account/home#/projects/37949)
- `raw/wrtds` = This directory contains daily histories of discharge (Q) in units of cubic meters per second and total phosphorus (TP) in units of mg/L for each river created using the weighted regressions on time, discharge, and season (WRTDS) method (Hirsch et al., 2010).
- `clean` = processed data. All processing scripts are in the `scripts` directory
- `shapefiles` = shapefiles used in this project

##  notebooks
This directory contains the python code used to generate figures.
For display purposes, some figures were fine-tuned using Adobe software.

##  results
This directory contains final results from this project

- `figures` = graphics produced from this project
- `papers` = manuscripts produced from this project
- `presentation` = talks or posters of presented work

## scripts
This directory contains any pre-processing scripts

## doc
This directory contains documentation files

## References
Hirsch, R.M., et al.  (2010). Weighted regressions on time, discharge, and season (WRTDS), with an application to Chesapeake Bay river inputs. *JAWRA*, 46(5), 857-880, doi:[10.1111/j.1752-1688.2010.00482.x](http://onlinelibrary.wiley.com/doi/10.1111/j.1752-1688.2010.00482.x/abstract)
