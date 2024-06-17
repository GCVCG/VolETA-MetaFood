# This script is responsible to conditionally download the needed files from Nutrition 5k (N5k) dataset
# (https://github.com/google-research-datasets/Nutrition5k) 181.4 GB
# Please run this file for one time. It requires ~4hrs in a good internet speed. If you have a better internet connection
# You can use `gsutil` to download the N5k folder in parallel manner. It will be faster, but it could kill your local
# internet if you use your lab internet.

# clone a copy
wget -qO- https://storage.googleapis.com/nutrition5k_dataset/nutrition5k_dataset.tar.gz | bsdtar -zxvf- \
          --exclude 'dish_ids' \
          --exclude 'metadata' \
          --exclude 'README' \
          --exclude 'scripts' \
          --exclude 'realsense_overhead'

# remove empty directories
find nutrition5k_dataset/ -type d -empty -delete
# restructure the filesystem tree
mv nutrition5k_dataset/imagery/side_angles/ n5k360

echo "Data is ready: $(pwd)/n5k360"