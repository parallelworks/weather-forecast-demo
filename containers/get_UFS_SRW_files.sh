#!/bin/bash
#==========================================
# Automated download of the files necessary
# for building a UFS-SRW container.
#==========================================

wget https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/20210224-ubuntu18-nceplibs.gz

wget https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/config.sh

wget https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/run_all.sh

wget https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/ufs-srweather-app-Dockerfile

wget https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/fix_files.tar.gz

wget https://ftp.emc.ncep.noaa.gov/EIB/UFS/SRW/v1p0/natural_earth/natural_earth_ufs-srw-release-v1.0.0.tar.gz

wget https://ftp.emc.ncep.noaa.gov/EIB/UFS/SRW/v1p0/simple_test_case/gst_model_data.tar.gz

