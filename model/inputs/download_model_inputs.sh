#!/usr/bin/env bash
### ==========================================
### download_model_inputs.sh <YEAR> <DIR>
###     This script downloads binary
### model input for a specified year
### stored on figshare to a specified directory
###    inputs :
###  year = 2007, 2008, 2009, or 2010
###  dir = directory to move inputs to
###        if no dir is defined then
###        inputs are moved to ./inputs
###
###     example:
### ./downlooad_model_inputs.sh 2007
### (this will move inputs for the year 2007
### to a directory named ./inputs)
### =============================================

### This is just good practice
### prints errors if variables are not set
set -o errexit
set -o nounset

### NOT READY YET
