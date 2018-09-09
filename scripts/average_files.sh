#!/usr/bin/env bash
#
# Description : Average phos from 2007-2010
#################################################################
set -o errexit
set -o pipefail
set -o nounset

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### Select March - August
echo Parse out March - August ...
cdo seltimestep,60/243 ptr_tave.0000315360.pload.nc temp2007.nc
cdo seltimestep,61/244 ptr_tave.0000473040.pload.nc temp2008.nc
cdo seltimestep,60/243 ptr_tave.0000631152.pload.nc temp2009.nc
cdo seltimestep,60/243 ptr_tave.0000788832.pload.nc temp2010.nc

### Average these fiels
echo Average over files ...
cdo ensmean temp{2007..2010}.nc phos.3d.avg.2007-2010.nc

### Remove tempory files
echo Remove tempory files ...
rm ./temp2007.nc
rm ./temp2008.nc
rm ./temp2009.nc
rm ./temp2010.nc

echo Complate!
