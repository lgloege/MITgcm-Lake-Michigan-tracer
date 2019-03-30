# MMSD data

This contains bi-weekly observations from the Milwaukee Metropolitan Sewerage District (MMSD)
water quality monitoring program. Data was downloaded from http://www.waterbase.glwi.uwm.edu/mmsd/
as tab-seperated-valued and converted to .csv files using `cat INPUT.tsv | tr "\\t" "," > OUTPUT.csv`

This contains data from three surveys:
* Near Shore (NS)
* Outer Harbor (OH)
* South Shore (SS)

The data has the following units:
* Total phosphorus (TP) - mg/L

Scripts:
* parse.awk : this can be used to isolate years (I used python instead)

