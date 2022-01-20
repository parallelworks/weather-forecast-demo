#!/bin/bash
#===================================
# Wrapper to run the UFS SRW Docker
# container
#====================================

# Ensure environment variables are set
# Assumes ufs directory already exists
# under current user's home directory.
# $DOCKER_TEMP_DIR is only used *inside*
# the container so it is automatically created
# with the --mount option.
export HOST_TEMP_DIR="/home/`whoami`/ufs"
export DOCKER_TEMP_DIR=/tmp/docker

# Original commmand from instructions
# docker run --mount "type=bind,source=${HOST_TEMP_DIR},target=${DOCKER_TEMP_DIR}" -it ufs-srweather-app-20210219 bash --login

# Modified command b/c:
# 1) add --rm to remove container after close
# 2) add sudo to run docker
# 3) TODO: add $1 as the input script that runs in the container.
sudo docker run --rm --mount "type=bind,source=${HOST_TEMP_DIR},target=${DOCKER_TEMP_DIR}" -it parallelworks/ufs-srweather-app bash --login
