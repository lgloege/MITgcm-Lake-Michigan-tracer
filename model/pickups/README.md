## pickups

the `model_pickups.zip` contains pickups files to restart the simulation.
- `pickup.0000315360.*` are to start the simulation on January 1st 2007
- `pickup.0000473040.*` are to start the simulation on January 1st 2008
- `pickup.0000631152.*` are to start the simulation on January 1st 2009
- `pickup.0000788832.*` are to start the simulation on January 1st 2010

The model was "spunup" for two years using repeating 2007 physical and radiative forcing.
`pickup.0000315360.*` starts the simulation after this two year spinup.


## How do you pickup a simulation?
For example, let's say you want to start the simulation in 2007.
1. unzip the pickup files and move all the `pickup.0000315360.*` to the `running` directory
2. in `data.ptracers` set `PTRACERS_Iter0=315360`, which is the pickup number.
3. Now set the model's `startTime` that corresponds to pickup number 0000315360. The file `pickups_and_model_time.xlsx` facilitates this. If you start the simulation in 2007 then the pickup file you are using was created on a last day in 2006. Look at that day and you will see pickupnumber 0000315360 corresponds to a model time (in seconds) of 63072000. Okay, so in the `running/data`, make sure `startTime = 63072000`.
4. Now set the model's `endTime = 94608000`. This end time corresponds to December 31st 2007. The model time is in seconds. Convince yourself that (`endTime` - `startTime`) equals the number of seconds in a year (31,536,000). As a sanity check, you can and should refer to `pickups_and_model_time.xlsx`. Be careful when you run 2008, it's a leap year!!
5. Now change are the `startdate` and file paths to correpsond to 2007 inputs in:
    - `data.exf`
    - `data.lakeice`
    - `data.rivers`
6. set `the_run_name` in `data`
6. set `mnc_outdir_str` in `data.mnc`. This will be the the name of the folder where where model output is written to.
