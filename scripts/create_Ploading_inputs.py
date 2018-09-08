#!/Users/gloege/anaconda3/envs/cartopy/bin/python
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
import struct
import sys


def export_binary(filename, field, dtype='float32'):
    """
    !Export binary files that can be imported into the MITgcm.
    The files are big endian, and the datatype can either be
    'float64' (= double precision), or 'float32' (=single precision).

    Might not work for very large datasets.
    https://edoddridge.bitbucket.io/MITgcm_py/functions_8py_source.html
    """
    data = np.array(field, dtype=dtype)  # with defined precision, either float32 or float64
    if sys.byteorder == 'little':
        data.byteswap(True)
    fid = open(filename, "wb")
    data.tofile(fid)  # this does not work for very large data sets
    # fid.write(bytes(data)) # this is another option to write to binary
    fid.close()


def plot_input():
    """ plot location of river to check position """
    import matplotlib.pyplot as plt
    mask = (depth == 0)
    depthMask = np.ma.array(depth, mask=mask)
    plt.pcolor(lon, lat, depthMask)
    plt.plot(lon[lonInd], lat[latInd], 'r.')
    plt.plot(lon[lonInd + 1], lat[latInd], 'r.')
    plt.plot(lon[lonInd + 1], lat[latInd + 1], 'r.')
    plt.plot(lon[lonInd], lat[latInd + 1], 'r.')
    plt.show()


# Range of dates for input, select year you want
year = eval(input("Type year you want to process : "))
dateRange = ['01/01/' + str(year), '01/01/' + str(year + 1)]

# Conversion from liters to cubic meters
litersInCubicMeter = 1000

# Store fileName, lat of mouth and lon of mouth
# the coordinates are the river mouth
# these were determined by looking on Google Earth or
# taken from Wikipedia (I am sorry)
stations = {'Fox': ['Fox_053210.csv', 44.54, -88.005],
            'Manistee': ['Manistee_04126010.csv', 44.25, -86.34453],
            'Muskegon': ['Muskegon_04122030.csv', 43.227089, -86.341987],
            'St Joseph': ['St_Joseph_04102080.csv', 42.114167, -86.488333],
            'Grand': ['Grand_04119400.csv', 43.05835, -86.25088],
            'Manistique': ['Manistique_04057004.csv', 45.948, -86.246],
            'Pere Marquette': ['Pere_Marquette_04122500.csv', 43.951667, -86.460278],
            'Menominee': ['Menominee_383088.csv', 45.0947, -87.59121],
            'Kalamazoo': ['Kalamazoo_04108660.csv', 42.67669, -86.21531],
            'Milwaukee': ['Milwaukee_413640.csv', 43.025556, -87.894831],
            'Sheboygan': ['Sheboygan_603095.csv', 43.748976, -87.702149]}

# Lists the river names, its just the keys to stations
rivers = list(stations.keys())

# Loop over rivers
for RV in range(0, len(rivers)):
    riverName = rivers[RV]
    latMouth = stations[riverName][1]
    lonMouth = stations[riverName][2]

    # Read Q and TP data from csv
    fname = "/Users/gloege/Documents/Projects/MITgcm-Michigan-Phosphorus/data/raw/wrtds/" + stations[riverName][0]
    print('Processing : ' + fname)
    df = pd.read_csv(fname)
    df['Date'] = pd.to_datetime(df['Date'])

    # Select data (# Q=m3/s, TP=mg/L, flux = mg/s)
    mask = (pd.to_datetime(df['Date']) >= dateRange[0]) & (pd.to_datetime(df['Date']) <= dateRange[1])
    Q = df['Q'][mask].values
    TP = df['TP'][mask].values
    flux = Q * (TP * litersInCubicMeter)

    # Since do not have january 1 2011 value, just use  dec 31 2010
    if (year == 2010):
        flux = np.append(flux, [flux[-1]])

    # Read grid file
    gridDir = '/Users/gloege/Documents/Projects/MITgcm-Michigan-Phosphorus/data/raw/'
    gridFile = gridDir + 'grid_lake_michigan.nc'
    ds = xr.open_dataset(gridFile)
    depth = ds['Depth'].values
    lon = ds['X'].values
    lat = ds['Y'].values
    drF = ds['drF'].values  # r cell face separation
    rA = ds['rA'].values  # r face area at cell center
    dlon = np.diff(lon[0:2]) / 2
    dlat = np.diff(lat[0:2]) / 2
    volCell = rA * drF[0]  # volume of surface cell cubic meters

    # Find river mouth in grid (the comma unpacks the tuple)
    lonInd, = np.where((lon < lonMouth + dlon) & (lon > lonMouth - dlon))
    latInd, = np.where((lat < latMouth + dlat) & (lat > latMouth - dlat))

    # the river mouth location was fine tuned to best match reality
    if (riverName == 'Fox'):
        lonInd = lonInd + 1
        latInd = latInd + 1
    if (riverName == 'Manistee'):
        latInd = latInd + 1
    if (riverName == 'Muskegon'):
        lonInd = lonInd - 4
    if (riverName == 'Grand'):
        lonInd = lonInd - 2
    if (riverName == 'Manistique'):
        latInd = latInd - 2
    if (riverName == 'Pere Marquette'):
        lonInd = lonInd - 3
    if (riverName == 'Kalamazoo'):
        lonInd = lonInd - 2
    if (riverName == 'Menominee'):
        lonInd = lonInd - 1
    if (riverName == 'Sheboygan'):
        latInd = latInd - 1

    # add singleton dimension to flux
    flux = np.expand_dims(flux, axis=1) / volCell[latInd, lonInd]

    # Initialize tracer grid, zero matrix [366 1 276 200]
    # need an extra day (hence the 366) so the model can interpolate
    # between Dec 31 and Jan 1 of next year
    nt, nz = flux.shape
    ny, = lat.shape
    nx, = lon.shape
    surfaceForcing = np.zeros((nt, nz, ny, nx), dtype='f')

    # add flux
    surfaceForcing[:, 0, latInd, lonInd] = flux.reshape(-1, 1)

    # Sanity check and useful to help fine river mouth location
    print('latInd : {0} lonInd : {1}'.format(latInd, lonInd))
    print('surfaceForcing shape: {0}'.format(surfaceForcing.shape))
    print('flux shape: {0}'.format(flux.shape))
    print('sum : {0}'.format(surfaceForcing.sum()))

    # Write to binary file
    fileName = '/Users/gloege/Documents/Projects/MITgcm-Michigan-Phosphorus/model/inputs/' + riverName.replace(" ", "") + '_mgs_' + str(year) + '.bin'
    export_binary(fileName, surfaceForcing)
