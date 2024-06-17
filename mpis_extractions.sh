#!/bin/bash
# $1: nutrition5k_dataset/imagery/side_angles

#dirs=($(find $1 -maxdepth 1 -type d))
#for dir in "${dirs[@]:1}"; do
#  echo "mips extraction for $dir..."
#  docker run --gpus all --rm --volume /:/host --workdir /host$PWD n5k360/llff:latest bash imgs2mpis.sh $dir 360
#done

find $1 -mindepth 1 -maxdepth 1 -type d | parallel -I% --max-args 1 bash imgs2mpis.sh % 360