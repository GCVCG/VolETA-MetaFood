#!/bin/bash

bash parallel_key_frame_extraction.sh $1 5 2 C N
echo "Estimating camera poses ..."
bash parallel_pixsfm.sh $1
echo "Generating poses_bounds.npy..."
bash parallel_imgs2poses.sh $1
echo "Generating transforms.json..."
bash parallel_transforms.sh $1
echo "Generating transforms_train.json transforms_val.json transforms_test.json..."
bash parallel_llff2nerf.sh $1
echo "Cleaning the NeRF related files..."
bash cleanup_traversally.sh $1