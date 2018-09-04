#!usr/bin/awk -f
# ===============================================
# Calculate Phosphorus Flux : PFlux = Q*TP
# Col_1 = Time
# Col_2 = Discharge (Q)
# Col_3 = total phosphorus (TP)
#
# L. Gloege Dec. 2017
# ===============================================

# SET FIELD SEPARATORS
BEGIN{FS=","; OFS=","}

# PRINT HEADER
NR<=1{print $1,$2,$3,"PFlux"}

# MULTIPLY COLUMNS 2,3 AND PRINTS ALL COLUMNS
# 1000L = 1 m3, 1000000mg/1kg
NR>1{PFlux=$2*$3*(1000/1000000); print $1,$2,$3,PFlux}

# DUPLICATE LAST LINE
# NEEDED FOR LAST TIME STEP OF THE MODEL
#END{print "2011-01-01",$2,$3,PFlux}
