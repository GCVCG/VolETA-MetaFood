import json
import os
import numpy as np
from glob import glob
from PIL import Image, ImageDraw, ImageOps

output_dir = "crop/"
# creating the ground_truth folder if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

json_files = glob("./annotations/*.json")
# loading the json file
for image_json in json_files:
    with open(image_json) as file:
        data = json.load(file)
    # read image as RGB and add alpha (transparency)
    # https://github.com/python-pillow/Pillow/issues/4703
    im = Image.open("images/" + data["imagePath"])
    
    im = ImageOps.exif_transpose(im)
    im = im.convert("RGBA")
    # convert to numpy (for convenience)
    imArray = np.asarray(im)

    filepath = data["imagePath"]
    filename = filepath.split(".")[0]
    print(filename)
    # creating a new ground truth image
    # mask = np.zeros((data["imageHeight"], data["imageWidth"]), dtype='uint8')
    for shape in data['shapes']:
        # mask = cv2.fillPoly(mask, [np.array(shape['points'], dtype=np.int32)], 255)
        polygon = [tuple(row) for row in shape['points']]

        maskIm = Image.new('L', (data["imageWidth"], data["imageHeight"]), 0)
        ImageDraw.Draw(maskIm).polygon(polygon, outline=1, fill=1)
        mask = np.array(maskIm)
        # assemble new image (uint8: 0-255)
        newImArray = np.empty(imArray.shape, dtype='uint8')

        # colors (three first columns, RGB)
        newImArray[:, :, :3] = imArray[:, :, :3]

        # transparency (4th column)
        newImArray[:, :, 3] = mask * 255
        # back to Image from numpy
        newIm = Image.fromarray(newImArray, "RGBA")
        newIm.save(os.path.join(output_dir, filename + ".png"))
