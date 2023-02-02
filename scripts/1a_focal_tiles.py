import xarray as xr
import rioxarray
import os
import time
import itertools
import numpy as np

# goal of this script is to run focal analyses to speed up my time in sampling so i can iterate quicker and run more models with various restrictions on the sampling regime

tiles_focal = "E:/Sync/Masters/analysis_sem/scratch/tiles_focal"

forest_in = os.path.join(tiles_focal, "forests", "input")

if not os.path.isdir(forest_in.replace("input", "output")):
    os.mkdir(forest_in.replace("input", "output"))

forest_tiles = [os.path.join(forest_in, x) for x in os.listdir(forest_in) if x.endswith(".dat")]

for tile in forest_tiles:
    print(tile)
    open_tile = xr.open_dataset(tile, engine = "rasterio").to_array()

    nptile = open_tile.data[0, 0, ...]

    stack = np.empty((nptile.shape[0]+2, nptile.shape[1]+2, 9))

    for index, (xshift, yshift) in enumerate(itertools.product([-1, 0, 1], [-1, 0, 1])):
        # print(xshift, yshift)
        stack[xshift+1:nptile.shape[0]+xshift+1, yshift+1:nptile.shape[1]+yshift+1, index] = nptile

    valid_locs = np.ptp(stack, axis=-1) == 0
    np.count_nonzero(valid_locs)

    valid_locs.shape

    open_tile.data[0, 0, ...] = valid_locs[1:-1, 1:-1]

    savename = tile.replace("input", "output")
    
    open_tile.squeeze().rio.to_raster(savename, driver = "envi")

struct_in = os.path.join(tiles_focal, "structure", "input")

if not os.path.isdir(struct_in.replace("input", "output")):
    os.mkdir(struct_in.replace("input", "output"))

struct_folds = os.listdir(struct_in)

for fold in struct_folds:
    struct_tiles = [os.path.join(struct_in, fold, x) for x in os.listdir(os.path.join(struct_in, fold)) if x.endswith(".dat")]

    for tile in struct_tiles:
        print(tile)
        open_tile = xr.open_dataset(tile, engine = "rasterio").to_array()

        nptile = open_tile.data[0, 0, ...]

        stack = np.empty((nptile.shape[0]+2, nptile.shape[1]+2, 9))

        for index, (xshift, yshift) in enumerate(itertools.product([-1, 0, 1], [-1, 0, 1])):
            # print(xshift, yshift)
            stack[xshift+1:nptile.shape[0]+xshift+1, yshift+1:nptile.shape[1]+yshift+1, index] = nptile

        valid_locs = np.std(stack, axis=-1) / np.mean(stack, axis = -1) <= 0.5
        np.count_nonzero(valid_locs)

        valid_locs.shape

        open_tile.data[0, 0, ...] = valid_locs[1:-1, 1:-1]

        savename = tile.replace("input", "output")

        if not os.path.isdir(os.path.dirname(savename)):
            os.mkdir(os.path.dirname(savename))

        open_tile.squeeze().rio.to_raster(savename, driver = "envi")


del stack
del nptile
del open_tile