#!/Users/gloege/anaconda3/bin/python
"""
Prepare Phosphorous loading data for input into model
Matt Diebel created input files using WRTDS method

Q  - cubic meters per second (cms)
TP - mg/L
flux - (Q*TP*1000), units are mg/s (note mg/m3 = ug/l)
You then divide by volume of grid cell at river mouth to get
flux = [mg/m3/s]

L. Gloege - September 16, 2017
"""

import numpy as np
import pandas as pd
import xarray as xr
import matplotlib.pyplot as plt
import struct
import sys

# Range of dates for input, select year you want
year = eval(input("Type year you want to process : "))
dateRange = ['01/01/' + str(year), '01/01/' + str(year + 1)]

# Conversion from liters to cubic meters
litersInCubicMeter = 1000

# Store fileName, lat of mouth and lon of mouth
stations = {'Milwaukee': ['Milwaukee_413640.csv', 43.025556, -87.894831],
            'Sheboygan': ['Sheboygan_603095.csv', 43.748976, -87.702149],
            'Fox': ['Fox_053210.csv', 44.54, -88.005],
            'Menominee': ['Menominee_383088.csv', 45.0947, -87.59121],
            'Manistique': ['Manistique_04057004.csv', 45.948, -86.246],
            'Manistee': ['Manistee_04126010.csv', 44.25, -86.34453],
            'Pere Marquette': ['Pere_Marquette_04122500.csv', 43.951667, -86.460278],
            'Muskegon': ['Muskegon_04122030.csv', 43.227089, -86.341987],
            'Grand': ['Grand_04119400.csv', 43.05835, -86.25088],
            'Kalamazoo': ['Kalamazoo_04108660.csv', 42.67669, -86.21531],
            'St Joseph': ['St_Joseph_04102080.csv', 42.114167, -86.488333]}

# Lists the river names, its just the keys to stations
rivers = list(stations.keys())

load = np.zeros(len(rivers))

# Loop over rivers
print('river,pload[MTyr]')
for RV in range(0, len(rivers)):
    riverName = rivers[RV]
    latMouth = stations[riverName][1]
    lonMouth = stations[riverName][2]

    # Read Q and TP data from csv
    fname = "/Users/gloege/Documents/Projects/lakeMichigan/data/wrtds/" + \
        stations[riverName][0]
#    print('Processing : ' + fname)
    df = pd.read_csv(fname)
    df['Date'] = pd.to_datetime(df['Date'])

    # Select data (# Q=m3/s, TP=mg/L, flux = mg/s)
    mask = (pd.to_datetime(df['Date']) >= dateRange[0]) & (
        pd.to_datetime(df['Date']) <= dateRange[1])
    Q = df['Q'][mask].values
    TP = df['TP'][mask].values
    flux = Q * (TP * litersInCubicMeter)

    # Since do not have january 1 2011 value, just use  dec 31 2010
    if (year == 2010):
        flux = np.append(flux, [flux[-1]])

    dx = 86400
    load[RV] = np.trapz(flux, dx=dx) / 1E6 / 1000
    # print("{},{}".format(riverName,round(load[RV],0)))
    print(",{}".format(round(load[RV], 0)))
