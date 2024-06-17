#!/bin/bash

# Some images contains high amount of features (i.e. rich scene background objects: bike, ball, textured, etc) to be
# paralleled. Since it is fully utilise the GPU (100%), we make it sequential. If you see your data features can be
# paralleled, increase --jobs parameter with the suitable number based on your GPU.
find $1 -mindepth 1 -maxdepth 1 -type d | parallel -I% --max-args 1 --jobs 1 --linebuffer python3 pixelsfm.py --work_dir=%