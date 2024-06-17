#!/bin/bash
# A bash script to cleanup all the additional files. For debugging purposes, you can simply remove the include of this
# file.
find $1 \( -name features.h5 -o -name matches.h5 -o -name pairs-sfm.txt -o -name refined_keypoints.h5 -o -name hloc -o -name colmap_text -o -name s2dnet_featuremaps_sparse.h5 \) -exec rm -rf {} +;