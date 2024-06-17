from hloc import extract_features, match_features, reconstruction, pairs_from_exhaustive, visualization
from hloc.visualization import plot_images, read_image
from hloc.utils.viz_3d import init_figure, plot_points, plot_reconstruction, plot_camera_colmap

from pixsfm.util.visualize import init_image, plot_points2D
from pixsfm.refine_hloc import PixSfM

from pathlib import Path

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--work_dir', type=str,
                    help='The working directory that contains `images` directory to scan')
parser.add_argument('--vis', action='store_true', default=False)

args = parser.parse_args()

work_dir = args.work_dir
print("Structure from Motion: ", work_dir)

images = Path(work_dir)
outputs = Path(work_dir + '/sparse')
# if outputs.is_dir():
#     exit()
sfm_pairs = outputs / 'pairs-sfm.txt'
loc_pairs = outputs / 'pairs-loc.txt'
features = outputs / 'features.h5'
matches = outputs / 'matches.h5'

ref_dir = outputs / "0"


feature_conf = extract_features.confs['superpoint_max']
matcher_conf = match_features.confs['superglue']


references = [str(p.relative_to(images)) for p in (images / 'images/').iterdir()]
print(len(references), "mapping images")
plot_images([read_image(images / r) for r in references[:4]], dpi=50)

extract_features.main(feature_conf, images, image_list=references, feature_path=features)
pairs_from_exhaustive.main(sfm_pairs, image_list=references)
match_features.main(matcher_conf, sfm_pairs, features=features, matches=matches)

# run pixsfm
# Some scenes has lots of features such as mip-nerf360 dataset. For that reason, we apply low_memory constants, for
# better memory handling.
sfm = PixSfM({
    "dense_features": {"max_edge": 1024, "use_cache": True, "cache_format": "chunked", "overwrite_cache": True,
                       "load_cache_on_init": False},
    'KA': {'dense_features': {'use_cache': True}, 'max_kps_per_problem': 1000},
    'BA': {'strategy': 'costmaps'}
})
refined, sfm_outputs = sfm.reconstruction(ref_dir, images, sfm_pairs, features, matches, image_list=references)

print("Refined", refined.summary())

if args.vis:
    fig3d = init_figure()
    args = dict(max_reproj_error=3.0, min_track_length=2, cs=1)
    plot_reconstruction(fig3d, refined, color='rgba(0, 255, 0, 0.5)', name="refined", **args)
    fig3d.show()

    img = refined.images[refined.reg_image_ids()[0]]
    cam = refined.cameras[img.camera_id]
    fig = init_image(images / img.name)
    plot_points2D(fig, [p2D.xy for p2D in img.points2D if p2D.has_point3D()])
    plot_points2D(fig, cam.world_to_image(img.project(refined)), color='rgba(255, 0, 0, 0.5)')
    fig.show()

