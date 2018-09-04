#!/bin/bash
#===================================================
# This utility simply removes any whitespace
# that may be in the file
#===================================================

# WHICH FILES TO REMOVE WHITESPACE FROM
echo "File(s) to remove whitespace from :"
read FILEPATH

# LOOP OVER FILES IN PATH
for FL in $( ls $FILEPATH )
do
    echo "Removing whitespace from: ${FL}"
    tr -d '\r' < ${FL} > tmp.txt
    mv tmp.txt ${FL}
done
