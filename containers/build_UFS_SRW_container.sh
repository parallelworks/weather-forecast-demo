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
# going to rebuild the container
# based on changes in the dockerfile,
# but there are no changes to this base
# image. (I.e. The first time this
# command is run, the base image is
# saved in the Docker cache for use later.)
docker import 20210224-ubuntu18-nceplibs.gz import-nceplibs-20220119

docker build -t parallelworks/ufs-srweather-demo:v1.32cpu -f ufs-srweather-app-Dockerfile .

# To send this container for use elsewhere,
# you can either:
# docker push parallelworks/ufs-srweather-demo:v1.32cpu
# or:
# docker save --output="ufs-srweather-demo.tar" parallelworks/ufs-srweather-demo:v1.32cpu
# The first option sends it to a Docker Hub
# registry, the second option creates a giant
# file for use later that you can import,
# just the docker import command, above.
