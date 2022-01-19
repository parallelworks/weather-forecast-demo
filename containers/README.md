# Containers for weather-forecast-demo

Intro here.

Based on the following:
1. [UFS SRW Users' Guide](https://ufs-srweather-app.readthedocs.io/en/ufs-v1.0.1/Docker.html)
2. [NCEPLIBS-external documentation](https://github.com/NOAA-EMC/NCEPLIBS-external/blob/ufs-v2.0.0/doc/README_ubuntu_gnu.txt)

The first link requires downloading 7 files.  Their download
is automated in `get_UFS_SRW_files.sh`.  The files are:
1. [NCEPLIBS container](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/20210224-ubuntu18-nceplibs.gz)
2. [config.sh](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/config.sh)
3. [run_all.sh](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/run_all.sh)
4. [ufs-srweather-app-Dockerfile](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/ufs-srweather-app-Dockerfile)
5. [fix_files.tar.gz](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/fix_files.tar.gz)
6. [Native Earth files](https://ftp.emc.ncep.noaa.gov/EIB/UFS/SRW/v1p0/natural_earth/natural_earth_ufs-srw-release-v1.0.0.tar.gz)
7. [Model input data](https://ftp.emc.ncep.noaa.gov/EIB/UFS/SRW/v1p0/simple_test_case/gst_model_data.tar.gz)

