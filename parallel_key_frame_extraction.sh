#!/bin/bash

# bash parallel_key_frame_extraction.sh LLFF/n5k360/360_4 5 2
# LLFF/n5k360/360_4 is parent directory
# 5 is the frame nth
# 2 is the hamming distance

# Rename files, because order is important
#find $1 -maxdepth 2 -type f -name camera_D.h264 -printf "echo mv '%h/%f' '%h/camera_1.h264\n'" | bash | bash | bash
#find $1 -maxdepth 2 -type f -name camera_A.h264 -printf "echo mv '%h/%f' '%h/camera_2.h264\n'" | bash | bash | bash
#find $1 -maxdepth 2 -type f -name camera_B.h264 -printf "echo mv '%h/%f' '%h/camera_3.h264\n'" | bash | bash | bash
#find $1 -maxdepth 2 -type f -name camera_C.h264 -printf "echo mv '%h/%f' '%h/camera_4.h264\n'" | bash | bash | bash

find $1 -mindepth 1 -maxdepth 1 -type d | parallel -I% --max-args 1 --linebuffer bash key_frame_extraction.sh % $2 $3 $4 $5