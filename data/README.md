<h1 align="center"> Data </h1>

This directory contains model output and other data analyzed in this project

- `raw` = Thid directory contains raw unprocessed model output
- `clean` = processed data. All processing scripts are in the `scripts` directory
- `shapefiles` = shapefiles used in this project

## Data Raw
A description of of the raw data is provided below

##### WRTDS
This directory contains daily histories of discharge (Q) in units of cubic meters per second and total phosphorus (TP) in units of mg/L for each river created using the weighted regressions on time, discharge, and season (WRTDS) method ([Hirsch et al., 2010](http://onlinelibrary.wiley.com/doi/10.1111/j.1752-1688.2010.00482.x/abstract)).

Phosphorus flux in units of mg/m3/s is estimated from daily estimates of Q and TP from WRTDS.
These phosphorus fluxes are inputs for to the model. The code used to create these inputs
is contains in the `scripts` directory. The `output_3D` directory contains daily 3D model output available via figshare.

##### Daily output of surface phosphorus concentration for each river
* [ptr_tave.0000315360.surf.nc](https://figshare.com/articles/ptr_tave_0000315360_surf_nc/7040042) contains 2007 output
* [ptr_tave.0000473040.surf.nc](https://figshare.com/articles/ptr_tave_0000473040_surf_nc/7040048) contains 2008 output
* [ptr_tave.0000631152.surf.nc](https://figshare.com/articles/ptr_tave_0000631152_surf_nc/7040051) contains 2009 output
* [ptr_tave.0000788832.surf.nc](https://figshare.com/articles/ptr_tave_0000788832_surf_nc/7043378) contains 2010 output

##### Daily output of 3D phosphorus concentration for each river ~~each file is ~24Gb~~
* [ptr_tave.0000315360.glob.nc](https://figshare.com/articles/ptr_tave_0000315360_surf_nc/7040042) contains 2007 output
* [ptr_tave.0000473040.glob.nc](https://figshare.com/articles/ptr_tave_0000473040_surf_nc/7040048) contains 2008 output
* [ptr_tave.0000631152.glob.nc](https://figshare.com/articles/ptr_tave_0000631152_surf_nc/7040051) contains 2009 output
* [ptr_tave.0000788832.glob.nc](https://figshare.com/articles/ptr_tave_0000788832_surf_nc/7043378) contains 2010 output

##### Daily output of 3D temperature and current velocities ~~each file is ~14Gb~~
* [tave.0000315360.glob.nc](https://figshare.com/articles/ptr_tave_0000315360_surf_nc/7040042) contains 2007 output
* [tave.0000473040.glob.nc](https://figshare.com/articles/ptr_tave_0000473040_surf_nc/7040048) contains 2008 output
* [tave.0000631152.glob.nc](https://figshare.com/articles/ptr_tave_0000631152_surf_nc/7040051) contains 2009 output
* [tave.0000788832.glob.nc](https://figshare.com/articles/ptr_tave_0000788832_surf_nc/7043378) contains 2010 output

##### 2010 US census data
US census county population estimates is used to see if population may explain
some of the relationship between phosphorus load and service stress.
The population of the county the river mouth is in was used for this.
Thid data is visualized in Supplemental Figure 7.
* [co-est2017-alldata.csv](https://www2.census.gov/programs-surveys/popest/datasets/2010-2017/counties/totals/co-est2017-alldata.csv) contains county population estimates for 2010-2017. A description of the data is available [here](https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2017/co-est2017-alldata.pdf)


## Shapefiles
This contains shapefiles used in this project. These are only used for display purpose in Figure 1.
- `glwsheds` - shapefile of Great Lakes HUC 08 sub-basin boundaries. I can not remember how I acquired this specific dataset.
However, this data should be contained in the [Watershed Boundary Dataset](https://nhd.usgs.gov/wbd.html).

These were not used in this study, but I don't want to forget these links:
- shapefile of the Great Lakes is available [here](http://archive.lib.msu.edu/maps/temp/Patron_Projects/Marquette_StudyArea/Shapefiles/)
- shapefiles of each Great Lake and its watershed are available [here](https://www.sciencebase.gov/catalog/item/530f8a0ee4b0e7e46bd300dd)

## Data Clean
This directory contains processed data. The `scripts` directory contains the code used to process all the raw data.
Some of the processed data is too large to store here. All the raw data is available and the processing scripts are available
to re-generate these files.

