#!/usr/bin/env bash
### ===================================================================
### setup_model_environment.sh
###    This script downloads inputs and pickup files from figshare
###    so you can run MITgcm-Michigan-phosphorus
###    and start the model in 2007, 2008, 2009, or 2010
###    Pickup files are after a 2 years spinup with repeating
###    2007 forcing
###
###  L. Gloege 2018
### ===================================================================
set -o errexit
set -o nounset

### ===================================================================
### Set paths
### ===================================================================
INPUTS_2007='https://ndownloader.figshare.com/files/12993452'
INPUTS_2008='https://ndownloader.figshare.com/files/12993587'
INPUTS_2009='https://ndownloader.figshare.com/files/12993596'
INPUTS_2010='https://ndownloader.figshare.com/files/12993620'
PICKUPS_2007_2010='https://ndownloader.figshare.com/files/???????'

### ===================================================================
### Pickups
### ===================================================================
echo 'Doownload and extract pickups'
wget ${PICKUPS_2007_2010}
tar -xvzf $(basename ${PICKUPS_2007_2010})
rm $(basename ${PICKUPS_2007_2010})

### ===================================================================
### Create inputs directory if does not exist.
### Wipes any contents in it
### ===================================================================
if [ -d inputs ]  ; then rm -Rf inputs ; fi
if [ ! -d inputs ] ; then mkdir inputs ; fi
cd inputs

#### Gets inputs for 2007
wget ${INPUTS_2007}
tar -xvzf $(basename ${INPUTS_2007})
rm $(basename ${INPUTS_2007})

### Gets inputs for 2008
wget ${INPUTS_2008}
tar -xvzf $(basename ${INPUTS_2008})
rm $(basename ${INPUTS_2008})

### Gets inputs for 2009
wget ${INPUTS_2009}
tar -xvzf $(basename ${INPUTS_2009})
rm $(basename ${INPUTS_2009})

### Gets inputs for 2010
wget ${INPUTS_2010}
tar -xvzf $(basename ${INPUTS_2010})
rm $(basename ${INPUTS_2010})
