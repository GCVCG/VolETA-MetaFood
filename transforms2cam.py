import json
import numpy as np
from scipy.spatial.transform import Rotation as R
import argparse


def nerf_to_ngp(xf):
    mat = np.copy(xf)
    mat = mat[:-1, :]
    mat[:, 1] *= -1  # flip axis
    mat[:, 2] *= -1
    mat[:, 3] *= 1.0  # scale
    mat[:, 3] += [0.5, 0.5, 0.5]  # offset

    mat = mat[[1, 2, 0], :]  # swap axis

    rm = R.from_matrix(mat[:, :3])

    # quaternion (x, y, z, w) and translation
    return rm.as_quat(), mat[:, 3] + 0.025


def smooth_camera_path(path_to_transforms, ):
    out = {"path": [], "time": 1.0}
    with open(path_to_transforms + '/transforms.json') as f:
        data = json.load(f)

    n_frames = len(data['frames'])

    xforms = {}
    for i in range(n_frames):
        file = int(data['frames'][i]['file_path'].split('/')[-1][:-4])
        xform = data['frames'][i]['transform_matrix']
        xforms[file] = xform

    xforms = dict(sorted(xforms.items()))
    indexes = list(xforms.keys())

    # linearly take 12 transformation from transforms.json
    for ind in np.linspace(0, n_frames - 1, 12, endpoint=True, dtype=int):
        q, t = nerf_to_ngp(np.array(xforms[indexes[ind]]))

        out['path'].append({
            "R": list(q),
            "T": list(t),
            "dof": 0.0,
            "fov": 43,
            "scale": 0,
            "slice": 0.0
        })

    with open(path_to_transforms + '/base_cam.json', "w") as outfile:
        json.dump(out, outfile, indent=2)


parser = argparse.ArgumentParser(
    description="Run instant neural graphics primitives with additional configuration & output options")

parser.add_argument("--transforms", default="data/nerf/fox", help="The path where the transforms.json exist")

args = parser.parse_args()

smooth_camera_path(args.transforms)
