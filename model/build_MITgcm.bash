#!/bin/bash
#======================================================================
# MITgcm build script
#
# rootdir = path to model source directory
# optfile = path to system optfile
# mods    = directory where you modified source files
#======================================================================
set -o errexit
set -o nounset

### vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
### MAKE SURE THESE PATHS ARE CORRECT
### vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
rootdir="/rigel/ocpbgc/users/luke/MITgcm-lm/source"
optfile="${rootdir}/tools/build_options/linux_ia64_ifort_habanero"
mods='/rigel/ocpbgc/users/luke/MITgcm-lm/code/LM_11_rivers'

### Load modules
#module load slurm
module load intel-parallel-studio/2017
module load netcdf-fortran/4.4.4
module load netcdf/gcc/64/4.4.0

### Create build directory if does not exist. Wipes any contents in it
if [ -d build ]  ; then rm -Rf build ; fi
if [ ! -d build ] ; then mkdir build ; fi
cd build

### Generates Makefile (use -devel for development)
${rootdir}/tools/genmake2 -mpi -mods=${mods} -optfile=${optfile} -rootdir=${rootdir}

### Compiles the model
make depend ; make
