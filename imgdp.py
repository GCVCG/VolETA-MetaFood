from imagededup.methods import PHash
phasher = PHash()

import argparse
parser = argparse.ArgumentParser()
parser.add_argument('--imgs_dir', type=str,
                    help='The images directory to scan')
parser.add_argument('--max_hamming_distance_threshold', type=int, default=1,
                    help='The images directory to scan')
args = parser.parse_args()

imgs_dir=args.imgs_dir

duplicates_list = phasher.find_duplicates_to_remove(image_dir=imgs_dir, max_distance_threshold=args.max_hamming_distance_threshold)
duplicates_list.sort()
print('To clean up: ', len(duplicates_list), duplicates_list)

import os
for f in duplicates_list:
    os.remove(imgs_dir + "/" + f)
# plot duplicates obtained for a given file using the duplicates dictionary
# from imagededup.utils import plot_duplicates
# plot_duplicates(image_dir='dish_1551226308/plts', duplicate_map=duplicates, filename='ukbench00120.jpg')
