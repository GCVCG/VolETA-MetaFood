# Building System in Docker

To build the system, you want to do the following
```bash
docker build -f Dockerfile_colmap -t="gcvcg/colmap:latest" .
docker build -f Dockerfile_pixsfm -t="gcvcg/pixsfm:latest" .
docker build -f Dockerfile_prenerf -t="gcvcg/prenerf:latest" .

cd ..


docker build -f docker/Dockerfile_volETA -t="gcvcg/voleta:latest" \
            --build-arg "USER_ID=$(id -u)" \
            --build-arg "GROUP_ID=$(id -g)" \
            --build-arg CUDA=1 --build-arg MASTER=1 .
```

To run
```bash
docker run -v $(pwd):/workspace \
           --gpus all \
           --shm-size 6G \
           --rm -it --entrypoint bash gcvcg/voleta:latest

# Or you can run a specific script:

docker run -v $(pwd):/workspace \
           -v /path/to/data:/workspace/data \
           --gpus all --shm-size 24G --name voleta --rm -it \
           --entrypoint bash -d gcvcg/voleta:latest \
           volETA_PointCloud.sh data/RCubeM2
            
docker logs -f voleta
```