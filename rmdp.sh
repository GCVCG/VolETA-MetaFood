#!/bin/bash

# bash rmdp.sh LLFF/challenging 1

# Sequential
#dirs=($(find $1 -maxdepth 1 -type d))
#for dir in "${dirs[@]:1}"; do
#  echo "remove duplicates for $dir..."
#  python imgdp.py --imgs_dir=$dir/images --max_hamming_distance_threshold=$2
#  ls "$dir/images" | cat -n | while read n f; do mv "$dir/images/$f" `printf "$dir/images/n_%03d.jpg" $n`; done
#  ls "$dir/images" | cat -n | while read n f; do mv "$dir/images/$f" `printf "$dir/images/%03d.jpg" $n`; done
#done

find $1 -mindepth 1 -maxdepth 1 -type d | parallel -I% --max-args 1 bash rmdp_single.sh % $2