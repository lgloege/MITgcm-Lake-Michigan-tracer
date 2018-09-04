#! /bin/bash
# --------------------------------------------------------------------------
# 1. Generates a Makefile for Michigan model in Build directory
# 2. run "make depend" to create dependcies
# 3. run "make" to compile the model
# 4. "mitgcmuv" is your compiled model
# --------------------------------------------------------------------------

# PATHES TO FILES AND DIRECTORIES USED TO COMPILE MITGCM
MAKEDEP='/scratch/luke/compile_michigan/codeLuke/tool/makedepend'
MODS='/scratch/luke/compile_michigan/codeLuke/modify/LM_11_rivers'
OPTFILE='/scratch/luke/compile_michigan/linux_amd64_iris'
ROOTDIR='/scratch/luke/compile_michigan/codeLuke/source'
GENMAKE2_PATH='/scratch/luke/compile_michigan/codeLuke/tool/genmake2'

# GENERATE MAKE FILE
${GENMAKE2_PATH} -mpi --makedepend=${MAKEDEP} -mods=${MODS} -optfile=${OPTFILE} -rootdir=${ROOTDIR}
