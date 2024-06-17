#!/bin/bash
find $1 -mindepth 1 -maxdepth 1 -type d | parallel -I% --max-args 1 --jobs 8 --linebuffer bash single_transforms.sh %