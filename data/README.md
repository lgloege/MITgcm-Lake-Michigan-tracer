## Data

This directory contains model output and other data analyzed in this project

- `raw/wrtds` = This directory contains daily histories of discharge (Q) in units of cubic meters per second and total phosphorus (TP) in units of mg/L for each river created using the weighted regressions on time, discharge, and season (WRTDS) method ([Hirsch et al., 2010](http://onlinelibrary.wiley.com/doi/10.1111/j.1752-1688.2010.00482.x/abstract)).
- `clean` = processed data. All processing scripts are in the `scripts` directory
- `shapefiles` = shapefiles used in this project

 Daily averages of surface phosphorus concentration for each river can be found [here](https://figshare.com/account/home#/projects/37949)

## Data Raw
This is raw or unprocessed data used in this project.

The `wrtds` directory contains daily estimates of discharge (Q) and total phosphorus (TP)
used to estimate the phosphorus flux for each river.
These phosphorus fluxes are inputs for to the model. The code used to create these inputs
is contains in the `scripts` directory. The `output_3D` directory contains daily 3D model output available via figshare.

Raw daily averages of surface phosphorus concentration is downloadable via Figshare:
* [ptr_tave.0000315360.surf.nc](https://figshare.com/articles/ptr_tave_0000315360_surf_nc/7040042) contains 2007 output
* [ptr_tave.0000473040.surf.nc](https://figshare.com/articles/ptr_tave_0000473040_surf_nc/7040048) contains 2008 output
* [ptr_tave.0000631152.surf.nc](https://figshare.com/articles/ptr_tave_0000631152_surf_nc/7040051) contains 2009 output
* [ptr_tave.0000788832.surf.nc](https://figshare.com/articles/ptr_tave_0000788832_surf_nc/7043378) contains 2010 output

US census county population estimates is used estimate the population at the mouth of each river.
* [co-est2017-alldata.csv](https://www2.census.gov/programs-surveys/popest/datasets/2010-2017/counties/totals/co-est2017-alldata.csv) contains county population estimates for 2010-2017. A description of the data is available [here](https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2017/co-est2017-alldata.pdf)


## Shapefiles
This contains shapefiles used in this project.

- `great_lakes` - shapefile of Great Lakes. [source](http://archive.lib.msu.edu/maps/temp/Patron_Projects/Marquette_StudyArea/Shapefiles/)
- `lake_michigan` - shapefile of Lake Michigan. [source](https://www.sciencebase.gov/catalog/item/530f8a0ee4b0e7e46bd300dd)
- `watershed` - shapeifile of Great Lakes watersheds. [source](https://www.sciencebase.gov/catalog/item/530f8a0ee4b0e7e46bd300dd)
- `sub-watershed` - shapefile of huc8 boundaries. [source](https://www.glahf.org/watersheds/)

## Data Clean
This directory contains processed data. The `scripts` directory contains the code used to process all the raw data.

