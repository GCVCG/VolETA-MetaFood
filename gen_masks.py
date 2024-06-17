import json
import cv2
import os
import numpy as np
from glob import glob

output_dir = "masks/"
# creating the ground_truth folder if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

json_files = glob("./annotations/*.json")
# loading the json file
for image_json in json_files:
    with open(image_json) as file:
        data = json.load(file)
    filename = data["imagePath"].split(".")[0]

    # creating a new ground truth image
    mask = np.zeros((data["imageHeight"], data["imageWidth"]), dtype='uint8')
    for shape in data['shapes']:
        # Make sure to change the corresponding value in OpenMVS.
        # DensifyPointCloud ... --ignore-mask-label object_color
        object_color = 255
        mask = cv2.fillPoly(mask, [np.array(shape['points'], dtype=np.int32)], object_color)
    mask = (255 - mask)
    # saving the ground truth masks
    cv2.imwrite(os.path.join(output_dir, filename) + ".mask.png", mask)
