#!/bin/bash
# ===============================================
# Process WRTDS data
# This just runs an awk script on each file
#
# L. Gloege Dec 2017
# ===============================================

# WHICH FILES TO REMOVE WHITESPACE FROM
echo "File(s) you to remove whitespace from :"
read FILEPATH

# LOOP OVER FILES IN DIRECTORY AND
for FL in $( ls $FILEPATH )
do
    # REMOVE WHITESPACE
    echo "Removing whitespace from: ${FL}"
    tr -d '\r' < ${FL} > tmp.txt
    mv tmp.txt ${FL}

    # RUN AWK SCRIPT ON EACH FILE
    echo "Processing: $FL"
    awk -f calculate_flux.awk $FL > tmp.txt
    mv tmp.txt $FL
done
