import pymeshlab as ml

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--mesh', type=str,
                    help='The mesh path to scan (PLY/OBJ)')
parser.add_argument('--scale_factor', type=float, default=5.56,
                    help='The scale factor for x-axis, this would be relatively changed for y-axis and z-axis')
args = parser.parse_args()

# Create a MeshSet object
ms = ml.MeshSet()

# Load the mesh (replace 'your_mesh.obj' with the path to your mesh file)
ms.load_new_mesh(args.mesh)

# Define the scaling factor along the x-axis
scaling_factor = args.scale_factor

ml.print_pymeshlab_version()
filters = ml.filter_list()

ml.print_filter_parameter_list('compute_matrix_from_scaling_or_normalization')

# Filters -> Scale, ... -> Transform: Scale, Normalise
ms.apply_filter("compute_matrix_from_scaling_or_normalization", axisx=scaling_factor)

# compute volumes
measures = ms.apply_filter("get_geometric_measures")

# todo: extract more values from here.
print("Mesh Volume: ", measures["mesh_volume"])

# todo: compute loss here
# we need the ground of truth.
