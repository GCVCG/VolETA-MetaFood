#!/bin/bash
find $1 -mindepth 1 -maxdepth 1 -type d | parallel -I% --max-args 1 --jobs 8 --linebuffer python3 llff2nerf.py % --images images --downscale 1