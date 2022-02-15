#!/bin/bash
#===================================
# Wrapper to run the UFS SRW Docker
# container
#====================================

# Make mount point
export PW_STORAGE=/pw/storage
sudo mkdir -p $PW_STORAGE
sudo chmod a+rwx $PW_STORAGE

# Mount Vcinity parallel file system
echo "=======> Mounting VCINITY DIRECT NFS to Azure EAST <======="
sudo mount -vvv -o sync,nolock,vers=4 40.71.67.138:/ultxvfs2 $PW_STORAGE

# HOST_TEMP_DIR matches mount point.  All
# input and output go to the mount.
# DOCKER_TEMP_DIR is only used *inside*
# the container so it is automatically created
# with the --mount option.
export HOST_TEMP_DIR=$PW_STORAGE/ufs
export DOCKER_TEMP_DIR=/tmp/docker

# Config and container run script are already
# on the file system.
sudo docker run --rm --mount "type=bind,source=${HOST_TEMP_DIR},target=${DOCKER_TEMP_DIR}" -it parallelworks/ufs-srweather-demo:v1.32cpu /bin/bash --login $DOCKER_TEMP_DIR/demo_script.sh
