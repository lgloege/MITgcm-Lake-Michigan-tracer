import numpy as np
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
