#!/bin/bash

DATASET_PATH=$1

# with masking
#colmap feature_extractor --database_path "$DATASET_PATH"/database.db \
#                         --image_path "$DATASET_PATH"/images \
#                         --ImageReader.mask_path "$DATASET_PATH"/masks \
#                         --ImageReader.single_camera "1" \
#                         --ImageReader.default_focal_length_factor "5.2" \
#                         --ImageReader.camera_mode "PINHOLE" \
#                         --SiftExtraction.use_gpu "1" \
#                         --SiftExtraction.max_image_size "1000" \
#                         --SiftExtraction.max_num_features "2048"

colmap feature_extractor --database_path "$DATASET_PATH"/database.db \
                         --image_path "$DATASET_PATH"/images \
                         --ImageReader.single_camera "1" \
                         --ImageReader.default_focal_length_factor "5.2" \
                         --SiftExtraction.use_gpu "1" \
                         --SiftExtraction.max_image_size "1000" \
                         --SiftExtraction.max_num_features "2048"



colmap exhaustive_matcher --database_path "$DATASET_PATH"/database.db \
                          --SiftMatching.use_gpu "1"

mkdir -p  "$DATASET_PATH"/sparse
mkdir -p  "$DATASET_PATH"/dense

# low-texture objects
# default values:
# --Mapper.min_num_matches 15
# --Mapper.abs_pose_min_num_inliers 30
# --Mapper.abs_pose_min_inlier_ratio 0.25
colmap mapper --database_path "$DATASET_PATH"/database.db \
              --image_path "$DATASET_PATH"/images \
              --output_path "$DATASET_PATH"/sparse \
              --Mapper.ba_global_function_tolerance=0.000001 \
              --Mapper.init_min_tri_angle=8 \
              --Mapper.min_focal_length_ratio=0.1 \
              --Mapper.max_focal_length_ratio=10 \
              --Mapper.ba_local_max_num_iterations=13 \
              --Mapper.ba_global_max_num_iterations=25 \
              --Mapper.ba_global_images_ratio=1.4 \
              --Mapper.ba_global_points_ratio=1.4 \
              --Mapper.ba_global_max_refinements=2


# Refining the model
python refine_sift.py --dataset "$DATASET_PATH" --outputs "$DATASET_PATH"/refined

# image_undistorter: Undistort images and/or export them for MVS or to external dense reconstruction software,
# such as CMVS/PMVS.
# undistorter avoid the need of fixing camera_model
colmap image_undistorter \
            --image_path "$DATASET_PATH"/refined/images \
            --input_path "$DATASET_PATH"/refined/sparse \
            --output_path "$DATASET_PATH"/refined/dense \
            --output_type COLMAP

# OpenMVS is only accepting text format
colmap model_converter \
    --input_path "$DATASET_PATH"/refined/dense \
    --output_path "$DATASET_PATH"/refined/dense \
    --output_type TXT


# Convert COLMAP data to something parsable for instant-ngp
python instant-ngp/scripts/colmap2nerf.py --colmap_db "$DATASET_PATH"/refined/dense/database.db \
                                          --colmap_camera_model SIMPLE_RADIAL \
                                          --images "$DATASET_PATH"/refined/dense/images/ \
                                          --text "$DATASET_PATH"/refined/dense/ \
                                          --out "$DATASET_PATH"/refined/dense/transforms.json

# todo: here you need to use `gen_imgs.py` to generate the masked images under /images/ folder.

# Run Instant-NGP
python instant-ngp/scripts/run.py --scene "$DATASET_PATH"/refined/dense --save_snapshot "$DATASET_PATH"/refined/dense/snapshot.msgpack \
                      --save_mesh "$DATASET_PATH"/refined/dense/scene.ply --n_steps 1000 --train

# You can use any PLY files in early stages
# scale_factor: based on our experiments, we find 5.56 is converting the unitless mesh into centimeters
python measurements.py --mesh "$DATASET_PATH"/refined/dense/scene.ply --scale_factor 14.55