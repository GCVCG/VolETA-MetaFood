#!/bin/bash

for (( i=0; i<32; i+=2 )); do
  echo "starting $i"

  # cleanup
  find n5k360/ch_failed -type d -empty -delete
  find n5k360/ch_failed -name colmap_output.txt -exec rm -rf {} +;
  find n5k360/ch_failed -name sparse -exec rm -rf {} +;
  find n5k360/ch_failed -name outputs -exec rm -rf {} +;
  find n5k360/ch_failed -name database.db -exec rm -rf {} +;

  # start over
  mv n5k360/ch_failed "n5k360/level$i"

  # remove similarity based on hamming distance $i
  bash rmdp.sh "n5k360/level$i" "$i"

  # start generating poses
  bash mpis_extractions.sh "n5k360/level$i"
done