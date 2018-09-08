#!/usr/bin/env bash
### ===================================================================
### download_model_inputs.sh
###     Downloads binary inputs for all four years from figshare
###     four directries are created when this script completes:
###     inputs_2007, inputs_2008, inputs_2009, inputs_2010
###
###  Usage:  ./downlooad_model_inputs.sh
###
###  output:
###    This will output three folders:
###    inputs_2007, inputs_2008, inputs_2009, inputs_2010
### ===================================================================
set -o errexit
set -o nounset

### Download and unzip 2007 model inputs
echo "Downloading inputs_2007.zip..."
wget https://ndownloader.figshare.com/files/12990956
echo "Unzipping inputs_2007.zip"
unzip 12990956
rm 12990956

### Download and unzip 2008 model inputs
echo "Downloading inputs_2008.zip..."
wget https://ndownloader.figshare.com/files/12991247
echo "Unzipping inputs_2008.zip"
unzip 12991247
rm 12991247

### Download and unzip 2009 model inputs
echo "Downloading inputs_2009.zip..."
wget https://ndownloader.figshare.com/files/12991235
echo "Unzipping inputs_2009.zip"
unzip 12991235
rm 12991235

### Download and unzip 2010 model inputs
echo "Downloading inputs_2010.zip..."
wget https://ndownloader.figshare.com/files/12991241
echo "Unzipping inputs_2010.zip"
unzip 12991241
rm 12991241
