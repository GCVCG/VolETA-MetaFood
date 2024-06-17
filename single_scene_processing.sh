#!/bin/bash

bash key_frame_extraction.sh $1 5 2 N N
echo "Estimating camera poses ..."
python3 pixelsfm.py --work_dir=$1
echo "Generating poses_bounds.npy..."
python3 LLFF/imgs2poses.py $1
echo "Generating transforms.json..."
bash single_transforms.sh $1
echo "Generating transforms_train.json transforms_val.json transforms_test.json..."
python3 llff2nerf.py $1 --images images --downscale 1
echo "Cleaning the NeRF related files..."
bash cleanup_traversally.sh $1