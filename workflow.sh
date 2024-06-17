#!/bin/bash
# building colmap
docker build -t "n5k360/colmap:latest" -f colmap/docker/Dockerfile .

# Before building, we need to prepare the llff pretrained model.
# It has nothing with the following docker build.
wget -nc http://cseweb.ucsd.edu/~viscomp/projects/LF/papers/SIG19/lffusion/llff_trained_model.zip -P LLFF/checkpoints
unzip LLFF/checkpoints/llff_trained_model.zip -d LLFF/checkpoints
rm -rf LLFF/checkpoints/llff_trained_model.zip

# Building llff; depends on "n5k360/colmap:latest"
# We highly recommend to install colmap locally instead of using docker image for faster processing.
docker build -t "n5k360/llff:latest" -f Dockerfile .

# Download filtered and extracted dataset
# You can use gsutil for highest download speed.
wget -qO- https://storage.googleapis.com/nutrition5k_dataset/nutrition5k_dataset.tar.gz | bsdtar -zxvf- \
          --exclude 'dish_ids' \
          --exclude 'metadata' \
          --exclude 'README' \
          --exclude 'scripts' \
          --exclude 'realsense_overhead' \
          --exclude 'camera_A.h264' \
          --exclude 'camera_D.h264'

# remove empty directories
find nutrition5k_dataset/ -type d -empty -delete
cd nutrition5k_dataset/imagery/side_angles/

# We see that not all folders contains the three cameras, so grouping them makes its easier to followup errors.
find . -maxdepth 1 -type d -exec /bin/bash -c 'a=( "{}"/* ); [[ ${#a[*]} = 4 ]]' ';' -print0 | xargs -0 -I {} mv {} ../360_4/
find . -maxdepth 1 -type d -exec /bin/bash -c 'a=( "{}"/* ); [[ ${#a[*]} = 3 ]]' ';' -print0 | xargs -0 -I {} mv {} ../360_3/
find . -maxdepth 1 -type d -exec /bin/bash -c 'a=( "{}"/* ); [[ ${#a[*]} = 2 ]]' ';' -print0 | xargs -0 -I {} mv {} ../360_2/

cd ../../../
# Extracting frames
cd nutrition5k_dataset/imagery/360_4 && bash parallel_key_frame_extraction.sh . 5 2

# back to the root
cd ../../..

# soft link the dataset to LLFF
mkdir -p  LLFF/n5k360
cp -r nutrition5k_dataset/imagery/360_4 LLFF/n5k360

cp -r imgdp.py imgs2mpis.sh parallel_key_frame_extraction key_frame_extraction.sh parallel_pixsmf.sh mpis_extractions.sh multi_level_conversion.sh rmdp.sh rmdp_single.sh LLFF/

bash multi_level_conversion.sh

# Since the rest of data cannot be handled by multiple cameras, we need to remove the data that related from `camera_C.h264`
find n5k360/ch_failed -type d -mindepth 2 -exec rm -rf {}/00{09..30}.jpg \;

mv n5k360/ch_failed/* n5k360/levelm/

find n5k360/levelm -type d -empty -delete
find n5k360/levelm -name colmap_output.txt -exec rm -rf {} +;
find n5k360/levelm -name sparse -exec rm -rf {} +;
find n5k360/levelm -name outputs -exec rm -rf {} +;
find n5k360/levelm -name database.db -exec rm -rf {} +;
find n5k360/levelm -name poses_bounds.npy -exec rm -rf {} +;

bash mpis_extractions.sh n5k360/levelm/

# That's it!
tar -zcvf n5k360.tar.gz n5k360