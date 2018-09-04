# WRTDS output

This is modeled daily phosphous loading for 11 tributaries
created using the WRTDS method described in (Hirsch et al. 2010 JAWRA)[]

The data has the following units:
* Tributary discharge (Q)  - cubic meters per second (cms)
* Total phosphorus (TP) - mg/L

Phorphorus flux can be calculated by multiplying discharge and concentration (Flux=Q*TP). 
To use to in MITgcm you will need to convert to kg/s, note that 1 m3 = 1000 L and 1 mg = 1000 ug

* Fox_053210.csv
* Milwaukee_413640.csv
* Grand_04119400.csv
* Muskegon_04122030.csv
* Kalamazoo_04108660.csv
* Pere Marquette_04122500.csv
* Manistee_04126010.csv
* Sheboygan_603095.csv
* Manistique_04057004.csv
* St Joseph_04102080.csv
* Menominee_383088.csv

