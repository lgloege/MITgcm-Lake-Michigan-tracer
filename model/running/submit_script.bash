#!/bin/bash
# ============================================
# SUBMISSION SCRIPT TO RUN MITgcm-michigan-P
# RUN JOB "sbatch ./submit_script.bash"
# ============================================
#SBATCH --job-name=michigan_11_tribs_
#SBATCH --partition=ace
#SBATCH --exclusive
#SBATCH -N 2-2
#SBATCH --ntasks=24
#SBATCH --time=23:00:00
#SBATCH --output=/home/lgloege/out.txt

# load modules
module purge
module load license_intel
module load impi
module load intel/15.0-2
module load hdf/4.2.9
module load hdf5/1.8.14
module load netcdf3

# Run name and executable name
RUN_NAME=run_LM_11_tribs
EXECUTABLE_NAME=mitgcmuv

# Run command
srun --export=ALL --cpu_bind=core --distribution=block:block /odyssey/scratch/luke/run_michigan/${RUN_NAME}/${EXECUTABLE_NAME}
