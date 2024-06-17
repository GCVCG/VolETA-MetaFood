#!/bin/bash

find $1 -mindepth 1 -maxdepth 1 -type d | parallel -I% --max-args 1 --jobs 7 --linebuffer python3 LLFF/imgs2poses.py %