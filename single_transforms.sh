#!/bin/bash

# bash parallel_pixsmf.sh
mkdir -p $1/colmap_text/
colmap model_converter --input_path $1/sparse/0 --output_path $1/colmap_text --output_type TXT

python3 colmap2nerf.py --images $1 \
                              --colmap_db $1/sparse/0/hloc/database.db \
                              --text $1/colmap_text/ \
                              --out $1/transforms.json

python3 transforms2cam.py --transforms $1