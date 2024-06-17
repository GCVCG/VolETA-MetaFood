#!/bin/bash

DATASET_PATH=$1
PROJECT_DIR=$(pwd)

# Cleanup
rm -rf "$DATASET_PATH"/sparse/ "$DATASET_PATH"/mvs/ "$DATASET_PATH"/database.db

# Attention: Resizing must be on the Mobile app.
# Resolution is related to the holes on the constructed mesh. We see the optimal resolution is in range 1156x867
#cp -r "$DATASET_PATH"/images "$DATASET_PATH"/images_2
#
#pushd "$DATASET_PATH"/images_2
#ls | xargs -P 8 -I {} mogrify -resize 50% {}
#popd
#
#cp -r "$DATASET_PATH"/images "$DATASET_PATH"/images_4
#
#pushd "$DATASET_PATH"/images_4
#ls | xargs -P 8 -I {} mogrify -resize 25% {}
#popd
#
#cp -r "$DATASET_PATH"/images "$DATASET_PATH"/images_8
#
#pushd "$DATASET_PATH"/images_8
#ls | xargs -P 8 -I {} mogrify -resize 12.5% {}
#popd
# ----------------------------------------------------------------------------------

# with masking - this could usually work for the high textured objects. The amount of feature must be high to avoid
# mapping failures
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
#
#
#
colmap exhaustive_matcher --database_path "$DATASET_PATH"/database.db \
                          --SiftMatching.use_gpu "1"
#
mkdir -p  "$DATASET_PATH"/sparse
#
## low-texture objects
## default values:
## --Mapper.min_num_matches 15
## --Mapper.abs_pose_min_num_inliers 30
## --Mapper.abs_pose_min_inlier_ratio 0.25
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

# For very edge cases, COLMAP split the models into disjoints models (folders), this happened because there is no general
# relationships between these subsets. https://github.com/colmap/colmap/issues/1225
cp -r "$DATASET_PATH"/sparse/0/*.bin "$DATASET_PATH"/sparse/
for path in ${1}/sparse/*/; do
    subset=$(basename ${path})
    if [ ${subset} != "0" ]; then
      echo "Warning, found disjoints models"
      colmap model_merger \
          --input_path1="$DATASET_PATH"/sparse \
          --input_path2="$DATASET_PATH"/sparse/${subset} \
          --output_path="$DATASET_PATH"/sparse
      colmap bundle_adjuster \
          --input_path="$DATASET_PATH"/sparse \
          --output_path="$DATASET_PATH"/sparse
    fi
done


# Manhattan-world stereo must be tested here:
# https://github.com/colmap/colmap/issues/1743
# Our observation said this is over-engineering. The n
#colmap model_orientation_aligner \
#    --image_path "$DATASET_PATH"/images  \
#    --input_path "$DATASET_PATH"/images \
#    --output_path "$DATASET_PATH"/sparse_aligned
## Refining the model

# mkdir -p "$DATASET_PATH"/refined/sparse
mkdir -p "$DATASET_PATH"/sparse/geo
colmap model_aligner --input_path "$DATASET_PATH"/sparse \
                     --output_path "$DATASET_PATH"/sparse/geo \
                     --ref_images_path "$DATASET_PATH"/locations.txt \
                     --ref_is_gps 0 \
                     --alignment_type ecef \
                     --robust_alignment 1 \
                     --robust_alignment_max_error 3

# This step might not be mandatory for the small datasets. Especially, after model_aligner!
# Comment out this line if you want to enable the refiner
# make sure to point into `colmap image_undistorter --input_path "$DATASET_PATH"/sparse/refined`
# python3 refine_sift.py --dataset "$DATASET_PATH" --outputs "$DATASET_PATH"/sparse/refined
#
#
#
mkdir -p "$DATASET_PATH"/mvs/dense
#
#
## image_undistorter: Undistort images and/or export them for MVS or to external dense reconstruction software,
## such as CMVS/PMVS.
## undistorter avoid the need of fixing camera_model
colmap image_undistorter \
            --image_path "$DATASET_PATH"/images \
            --input_path "$DATASET_PATH"/sparse/geo \
            --output_path "$DATASET_PATH"/mvs/dense \
            --output_type COLMAP
#
## OpenMVS is only accepting text format
colmap model_converter \
    --input_path "$DATASET_PATH"/mvs/dense/sparse \
    --output_path "$DATASET_PATH"/mvs/dense/sparse \
    --output_type TXT
#
#
## OpenMVS
cd "$DATASET_PATH"/mvs/dense
#
## Start the baseline scene.mvs
InterfaceCOLMAP -w . -i .  -o scene.mvs
#
## Building PointCloud with Masking
## the operation is expensive
## --max-resolution is not impacting the scaling factor.

# Important!
# Masks might need to be rotated.
# mogrify -rotate 270 *.png
DensifyPointCloud scene.mvs --mask-path ../../masks_omvs/ --ignore-mask-label 0 --filter-point-cloud 1 --max-resolution 512 --remove-dmaps 1

# Converting the PointCloud to Mesh
# todo: use --close-holes 50 for better reconstruction
# todo: use --smooth 5 for number of iterations to smooth the reconstructed surface (0 - disabled)
ReconstructMesh -w . scene_dense.mvs --close-holes 50 --smooth 5

# Refining the Mesh (optional, it is for complex geometry)
# it impacting the thickness of the surface, so it must needed.
# The operation is expensive
# it does not impact the final volume
# RefineMesh --resolution-level 1 scene_dense_mesh.mvs

# Optional, coloring the plan mesh for presentation purposes
#TextureMesh scene_dense_mesh_refine.mvs

# back to root
cd $PROJECT_DIR
# You can use any PLY files in early stages
# scale_factor: based on our experiments, we find 5.56 is converting the unitless mesh into centimeters
python3 measurements.py --mesh "$PROJECT_DIR"/"$DATASET_PATH"/mvs/dense/scene_dense_mesh.ply --scale_factor 1
# python3 measurements.py --mesh "$PROJECT_DIR"/"$DATASET_PATH"/mvs/dense/scene_dense_mesh_refine.ply --scale_factor 1