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

# New container images are created
# each time this step is run if
# previous images are not cleared.
# Comment this out if you're just
# going to rebuild the container.
#docker import 20210224-ubuntu18-nceplibs.gz import-nceplibs-20220119


docker build -t parallelworks/ufs-srweather-app -f ufs-srweather-app-Dockerfile .
