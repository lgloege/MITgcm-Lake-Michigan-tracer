pCO2 observations in Lake Superior suggest that offshore waters
are close to atmospheric pco2 while nearshore waters are supersaturated

want to include contribution of river runoff to lake doc

include the variable relationship between flow rate and river [DOC]
include fact that river DOC is primarily terrestrial and labile (separate pool in model)

cccccccccccccccc

in data.rivers:
ccccccccccccccccc
set DOC_RIVER = chosen DOC concentration in river if assuming constant river [DOC]
    mol/m3
    default is 0 mol/m3
set docmolmass = your chosen molar mass of DOC = default is 12.01 g/mol
c
set docscheme 
   1 is Urban
   2 is Geffen
   3 is Constant
   default is Constant

