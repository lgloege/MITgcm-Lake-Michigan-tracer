## Model
This directory contains all the code used to compile and run MITgcm-Michigan-Phosphorus.

- `source` = model source code (**do not modify these files**)
- `code` = modifications to source files
- `running` = configuration files used to run the model (plus initialization files)
- `setup_model_environment.sh` = Shell script to download that downloads input files and pickup files
- `build_MITgcm.bash` = Shell script to compile the model. This creates an executable that you will need to move to to the `running` directory.


code  running  source  README.md  build_MITgcm.bash  setup_model_environment.sh

## Setting up the model environment
The `setup_model_environment.sh` script creates two new directories `inputs` and `pickups`. Run this command:
```bash
./setup_model_environment.sh
```

The script uses the `wget` command to download the files. Don't have `wget` installed? No problem. If you are a mac users I highly recommend installing the [homebrew](https://brew.sh) package manager. This makes installing `wget` as simple as:
```bash
brew install wget
```

You can also follow the links below and manually download the pickup and input files.
Extract the files with `tar -xvzf file_name.tar.gz`.

- `pickups` = model pickup files. The script downloads the following pickup files:
    - [pickup files](https://figshare.com/articles/inputs_2007_zip/????)
- `inputs` = binary input files for the model. The script downloads the following inputs:
    - [inputs for 2007](https://figshare.com/articles/inputs_2007_zip/7064522)
    - [inputs for 2008](https://figshare.com/articles/inputs_2008_zip/7064768)
    - [inputs for 2009](https://figshare.com/articles/inputs_2009_zip/7064759)
    - [inputs for 2010](https://figshare.com/articles/inputs_2010_zip/7064765)

## Compile
The following steps describe how to compile the model

1. Make sure path to `source` directory is set properly in `build_MITgcm.bash`
2. Make sure path to `code` directory is set properly in `build_MITgcm.bash`
3. Set the path to your machine's build option file (i.e. optfile) in `build_MITgcm.bash`. MITgcm provides in common optfiles here `source/tools/build_options/`
4. The following command creates a `build` directory where the model is compiled:
```bash
./build_MITgcm.bash
```
5. If the model compiled properly, there is now an executable named `mitgcmuv` in `build`. Move this execuatble to `running`:
```bash
mv ./build/mitgcmuv ./running/
```
6. Now you are ready to run the model! See the Running the model section.

## Running the model
This directory contains the data files used to run the model. `bathy_Lake_Michigan_1min.bin` is a binary bathymetry file. The model was spunup using repeating 2007 forcing for two years. Files needed to "pickup" the simulation after spinup are contained in the `pickups` directory. You can pickup the simulation by setting the `startTime` in `running/data`. However, becuase pickup files are not created after each timestep (which would be overkill!) the pickup numbers do not correspond to the model time. The spreadsheet `pickups_to_model_time.xlsx` maps the pickup numbers onto model time (which is in seconds).

1. Make sure you moved the `mitgcmuv` executable from the build directory to `running`.
2. Change the paths in the data files to correct forcing files stored in the `inputs` directory. Run the following command:
```bash
grep inputs data*
```
Paths to input files should display in your terminal. It should look very similar to this:
```bash
data.exf: lwdownfile = '../inputs/xy.longwave.narr.new.2007.1min.bin',
data.exf: swdownfile = '../inputs/xy.shortwave.narr.new.2007.1min.bin',
data.exf: uwindfile  = '../inputs/xy.uwind.narr.new.2007.1min.bin',
data.exf: vwindfile  = '../inputs/xy.vwind.narr.new.2007.1min.bin',
data.exf: atempfile  = '../inputs/xy.temp.10m.narr.new.2007.1min.bin',
data.exf: aqhfile    = '../inputs/xy.shumid.narr.new.2007.1min.bin',
data.lakeice: icefracfile = '../inputs/icef.2007.1min.bin',
data.ptracers:  PTRACERS_initialFile='../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.ptracers:                       '../inputs/tracer_zero.bin',
data.rivers: rivflowfile='../inputs/Fox_mgs_2007.bin',
data.rivers:             '../inputs/Menominee_mgs_2007.bin',
data.rivers:             '../inputs/Manistique_mgs_2007.bin',
data.rivers:             '../inputs/Manistee_mgs_2007.bin',
data.rivers:             '../inputs/PereMarquette_mgs_2007.bin',
data.rivers:             '../inputs/Muskegon_mgs_2007.bin',
data.rivers:             '../inputs/Grand_mgs_2007.bin',
data.rivers:             '../inputs/Kalamazoo_mgs_2007.bin',
data.rivers:             '../inputs/StJoseph_mgs_2007.bin',
data.rivers:             '../inputs/Milwaukee_mgs_2007.bin',
data.rivers:             '../inputs/Sheboygan_mgs_2007.bin',
```
Notice how they all the files end with 2007. That means we are reading forcing files that correspond to 2007.
3. Since we are running a 2007 simulation. Let's make sure the startdate is set correctly:. Run the following:
```bash
grep startdate1 data*
```
You should see output that looks like this:
```bash
data.exf: atempstartdate1=20070101,
data.exf: aqhstartdate1=20070101,
data.exf: lwdownstartdate1=20070101,
data.exf: swdownstartdate1=20070101,
data.exf: uwindstartdate1=20070101,
data.exf: vwindstartdate1=20070101,
data.exf:## sfluxstartdate1=19920101,
data.exf_clim:# climsststartdate1  = 19970101,
data.exf_clim:# climsssstartdate1  = 19920101,
data.lakeice: icefracstartdate1=20070101,
data.lakeice:# icelatentstartdate1=20000101,
data.rivers: rivflowstartdate1=20070101,
```
Do not worry of the lines with `#`, those are comments. Notice that other lines contains `20070101`. That is good. It means the model will pickup the simulation starting on January 1st 2007. But now we need to provide the correct pickup file, becuase the model physics were spunup for two years.
4. Now let's make sure we are reading the correct pickup file. Run the following:
```bash
grep Iter0 data*
```
Do you see the following?
```bash
data.ptracers:  PTRACERS_Iter0=315360.,
```
the number 315360 corresponds to the pickupfile for 2007. Let's cp those files into running:
```bash
cp ../pickups/pickup*315360* .
```
These pickup files saved the model state after the spinup. We need to tell the model which timestep the pickup file corresponds to. I provide a file `pickup_to_timestep.xlsx` to facilitate this.

```bash
grep startTime data
```
and
```bash
grep endTime data
```

should display
```bash
 #startTime=0.,
 #startTime=31536000.,
 startTime=63072000.
```

and
```bash
# endTime=31536000.,
# endTime=63072000.,
 endTime=94608000.,
# endTime=126230400.,
```
Again, ignore all the `#` lines. Look at `pickup_to_timestep.xlsx` in the pickups directory
to convince yourself these values are correct.
5. Okay, now there are two things that you should change. Look the following:
```bash
grep the_run_name data
```
This name will appear in the netcdf files

```bash
grep mnc_outdir_str data.mnc
```
This name will be the directory name tiled output is saved to.
6. Now do one more look at each file be sure everything is set properly.
5. Now you can setup setup `run_1d_MITgcm_habanero.sh` according to the scheduler on your machine. Habanero uses slurm. So I would run the model like this:
```bash
sbatch ./run_1d_MITgcm_habanero.sh
```
Be aware that you will need to change some of the header parameters in this file.

Happy modeling!

## Notes on forcing data
Model input sources are provided below:
- Great Lakes bathymetry data is available [here](https://www.ngdc.noaa.gov/mgg/greatlakes/greatlakes.html)
- NARR atmospheric forcing fields are available [here](https://www.esrl.noaa.gov/psd/data/gridded/data.narr.html)
- Lake ice forcing is available [here](http://www.natice.noaa.gov/products/great_lakes.html).
- Tributary phosphorus fluxes were calculated from daily estimates of discharge and total phosphorus calculated using the [WRTDS method](http://onlinelibrary.wiley.com/doi/10.1111/j.1752-1688.2010.00482.x/abstract). These estimates were made by [Matthew Diebel](https://www.researchgate.net/profile/Matthew_Diebel) and are available in the `raw/wrtds` directory. The code used to calculate tributary phosphorus fluxes is in the `scripts` directory.

## Notes on pickup files

the `model_pickups.zip` contains pickups files to restart the simulation.
- `pickup.0000315360.*` are to start the simulation on January 1st 2007
- `pickup.0000473040.*` are to start the simulation on January 1st 2008
- `pickup.0000631152.*` are to start the simulation on January 1st 2009
- `pickup.0000788832.*` are to start the simulation on January 1st 2010

The model was "spunup" for two years using repeating 2007 physical and radiative forcing.
`pickup.0000315360.*` starts the simulation after this two year spinup.


## Notes on picking up a simulation
For example, let's say you want to start the simulation in 2007.
- in `data.ptracers` set `PTRACERS_Iter0=315360`, to be the pickup number. 315360 is to pickup on January 1st 2007.
- Now set the model's `startTime` in data that corresponds to the model timestep when the pickup was created. The file `pickups_and_model_time.xlsx` facilitates this. If you start the simulation in 2007 then the pickup file you are using was created on a last day in 2006. Look at that day and you will see pickupnumber 0000315360 corresponds to a model time (in seconds) of 63072000. Okay, so in the `running/data`, make sure `startTime = 63072000`.
- Now set the model's `endTime = 94608000`. This end time corresponds to December 31st 2007. The model time is in seconds. Convince yourself that (`endTime` - `startTime`) equals the number of seconds in a year (31,536,000). As a sanity check, you can and should refer to `pickups_and_model_time.xlsx`. Be careful when you run 2008, it's a leap year!!
- Now change are the `startdate` and file paths to correpsond to 2007 inputs in:
    - `data.exf`
    - `data.lakeice`
    - `data.rivers`



