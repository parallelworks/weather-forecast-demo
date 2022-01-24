#!/bin/bash
#=================================
# Automate the steps necessary to
# build the Docker container after
# files have been downloaded.
#=================================

# Files that require modifications
# have already been modified:
# 1. config.sh has 12 core options
#    (or rebuild for other # CPU)
# 2. Dockerfile has FROM container
#    image name updated.
# 3. Dockerfile has different branch

# If you do not use a .dockerignore
# or the Docker Build Kit, see
# https://stackoverflow.com/questions/26600769/build-context-for-docker-image-very-large
# you will end up with a Docker image
# that is too big.


# New container images are created
# each time this step is run if
# previous images are not cleared.
# Comment this out if you're just
# going to rebuild the container.
#docker import 20210224-ubuntu18-nceplibs.gz import-nceplibs-20220119


docker build -t parallelworks/ufs-srweather-demo:v1.04cpu -f ufs-srweather-app-Dockerfile .
