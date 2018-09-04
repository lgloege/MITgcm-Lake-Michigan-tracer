import numpy as np
import xarray as xr


def get_model_grid():
    """
    docstring
    SA : surface area of each cell (m2)
    depth : depth of each cell (m)
    lon : longitude (deg)
    lat : latitude (deg)
    drF : r cell face separation (m)
    rA : face area at cell (m)
    dlon : diff in lon (deg)
    dlat : diff in lat (deg)
    volCell : volume of surface cells (m3)
    volLake : volume of lake (m3)
    """

    # Read grid file
    gridDir = '/Users/gloege/Documents/Projects/MITgcm-Michigan-Phosphorus/data/raw/'
    gridFile = gridDir + 'grid_lake_michigan.nc'
    ds = xr.open_dataset(gridFile)

    # Variables
    SA = ds['rA'].values
    depth = ds['Depth'].values
    lon = ds['X'].values
    lat = ds['Y'].values
    drF = ds['drF'].values
    rA = ds['rA'].values
    dlon = np.diff(lon[0:2]) / 2
    dlat = np.diff(lat[0:2]) / 2
    volCell = rA * drF[0]
    vol = SA * depth
    volLake = np.sum(vol.flat)

    # output
    out = {'SA': SA,
           'depth': depth,
           'lon': lon,
           'lat': lat,
           'drF': drF,
           'rA': rA,
           'dlon': dlon,
           'dlat': dlat,
           'volCell': volCell,
           'vol': vol,
           'volLake': volLake}

    return out
