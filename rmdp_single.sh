#!/bin/bash

# bash rmdp_single.sh LLFF/challenging/dish_xxxx 1
dir=$1
echo "remove duplicates for $dir..."
python imgdp.py --imgs_dir=$dir/images --max_hamming_distance_threshold=$2
ls "$dir/images" | cat -n | while read n f; do mv "$dir/images/$f" `printf "$dir/images/n_%03d.jpg" $n`; done
ls "$dir/images" | cat -n | while read n f; do mv "$dir/images/$f" `printf "$dir/images/%03d.jpg" $n`; done