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

Raw 3D fields are also available (**These are very large. 14-24Gb per year.**).
`ptr_tave` contains 3D tributary phosphorus concentration:
* [ptr_tave.0000315360.glob.nc](https://figshare.com/articles/ptr_tave_0000315360_surf_nc/7040042) contains 2007 output
* [ptr_tave.0000473040.glob.nc](https://figshare.com/articles/ptr_tave_0000473040_surf_nc/7040048) contains 2008 output
* [ptr_tave.0000631152.glob.nc](https://figshare.com/articles/ptr_tave_0000631152_surf_nc/7040051) contains 2009 output
* [ptr_tave.0000788832.glob.nc](https://figshare.com/articles/ptr_tave_0000788832_surf_nc/7043378) contains 2010 output

`tave` contains temperature and current velocities:
* [tave.0000315360.glob.nc](https://figshare.com/articles/ptr_tave_0000315360_surf_nc/7040042) contains 2007 output
* [tave.0000473040.glob.nc](https://figshare.com/articles/ptr_tave_0000473040_surf_nc/7040048) contains 2008 output
* [tave.0000631152.glob.nc](https://figshare.com/articles/ptr_tave_0000631152_surf_nc/7040051) contains 2009 output
* [tave.0000788832.glob.nc](https://figshare.com/articles/ptr_tave_0000788832_surf_nc/7043378) contains 2010 output

US census county population estimates is used estimate the population at the mouth of each river.
* [co-est2017-alldata.csv](https://www2.census.gov/programs-surveys/popest/datasets/2010-2017/counties/totals/co-est2017-alldata.csv) contains county population estimates for 2010-2017. A description of the data is available [here](https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2017/co-est2017-alldata.pdf)


## Shapefiles
This contains shapefiles used in this project. These are only used for display purpose.
- `glwsheds` - shapefile of Great Lakes HUC 08 sub-basin boundaries. I can not remember how I acquired this. For those interested, the [Watershed Boundary Dataset](https://nhd.usgs.gov/wbd.html) is a good place to start.

These were not used in this stuyd, but some may find them useful:
- shapefile of the Great Lakes is available [here](http://archive.lib.msu.edu/maps/temp/Patron_Projects/Marquette_StudyArea/Shapefiles/)
- shapefiles of each Great Lake and its watershed are available [here](https://www.sciencebase.gov/catalog/item/530f8a0ee4b0e7e46bd300dd)

## Data Clean
This directory contains processed data. The `scripts` directory contains the code used to process all the raw data.

