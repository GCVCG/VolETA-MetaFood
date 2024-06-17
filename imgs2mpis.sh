mkdir -p $1/outputs
python imgs2poses.py $1 || mv $1 n5k360/ch_failed/
# python imgs2mpis.py $1 $1/mpis_$2 --height $2
#python imgs2renderpath.py $1 $1/outputs/test_path.txt --spiral
#cd cuda_renderer && make && cd ..
#cuda_renderer/cuda_renderer $1/mpis_$2 $1/outputs/test_path.txt $1/outputs/test_vid.mp4 -1 .8 18
# python mpis2video.py $1/mpis_$2 $1/outputs/test_path.npy $1/outputs/test_vid.mp4 --crop_factor .8