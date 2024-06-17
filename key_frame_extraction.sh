#!/bin/bash

# Example:
#        bash key_frame_extraction.sh DIRECTORY SAMPLING_DEGREE HAMMING_DISTANCE CLEANUP ROTATION_DEGREE
# Where:
#        DIRECTORY        :  Is the directory/folder contains the scene video(s).
#        SAMPLING_DEGREE  :  Take Nth frame.
#        HAMMING_DISTANCE :  Larger hamming distance means less similarity across images.
#        CLEANUP          :  If `C`, the video will be removed after ffmpeg extraction. Otherwise, do nothing.
#        ROTATION_DEGREE  :  Rotation degree for the images after extraction. 180 for N5k.

dir=$1
echo "$dir"
mkdir -p "$dir/images"

cameras=$(find "$dir" -maxdepth 1 -type f | grep -E "\.h264$|\.webm$|\.flv$|\.vob$|\.ogg$|\.ogv$|\.drc$|\.gifv$|\.mng$|\.avi$|\.mov$|\.qt$|\.wmv$|\.yuv$|\.rm$|\.rmvb$|/.asf$|\.amv$|\.mp4$|\.m4v$|\.mp*$|\.m?v$|\.svi$|\.3gp$|\.flv$|\.f4v$")
echo "Detected: ${cameras}"
# Multi-videos for a scene means that this scene is taken from multiple cameras.
for camera in ${cameras}; do
    # take snapshots
    echo "Extracting ${camera}"
    filename=$(basename -- "$camera")
    ffmpeg -hide_banner -loglevel error -i ${camera} -vf "select=not(mod(n\,$2))" -vsync vfr "${dir}"/images/"${filename%.*}"_%03d.png
    # clean up if the cleanup flag is provided. Useful for large multi-scene data.
    [ "$4" = 'C' ] && rm -rf "${camera}"
done

echo "to lossless format?"
none_pngs=$(find "$dir/images" -maxdepth 1 -type f | grep -E "\.jpg$|\.JPG$|\.jpeg$")
for image in ${none_pngs} ;  do convert "$image" "${image%.*}.png" && rm -rf "$image" ; done

echo "Remove blur images..."
# fine-tune the threshold on your images, for example, in N5k dataset, 10 is best-fit threshold.
python3 blur_fft/blur_detection.py -i "$dir"/images --threshold 10 --remove

echo "removing duplicates"
python3 imgdp.py --imgs_dir="$dir/images" --max_hamming_distance_threshold=$3

# do rotation, if rotation degree is given.
[[ $5 == ?(-)+([0-9]) ]] && echo "rotating $5..." && mogrify -rotate "$5" "$dir/images/*.png"

echo "re-naming..."
ls "$dir/images" | cat -n | while read n f; do mv "$dir/images/$f" `printf "$dir/images/%04d.png" $n`; done

# Resize images.
# You can skip this part for later.
cp -r "$dir"/images "$dir"/images_2

pushd "$dir"/images_2
ls | xargs -P 8 -I {} mogrify -resize 50% {}
popd

cp -r "$dir"/images "$dir"/images_4

pushd "$dir"/images_4
ls | xargs -P 8 -I {} mogrify -resize 25% {}
popd

cp -r "$dir"/images "$dir"/images_8

pushd "$dir"/images_8
ls | xargs -P 8 -I {} mogrify -resize 12.5% {}
popd
