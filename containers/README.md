# Containers for weather-forecast-demo

These instructions are based on the [UFS SRW Users' Guide](https://ufs-srweather-app.readthedocs.io/en/ufs-v1.0.1/Docker.html).  You will need Docker and at least 100GB of disk space.  It takes about 5-10 mins to build
the container depending on size of machine.

## Step 1: Download files

The instructions requires downloading 7 files.  Their download
is automated in `get_UFS_SRW_files.sh`.  If you prefer to use
the publicly available Docker container and the scripts in this
repository, you do not need files #1, 2, 3, and 4.  The other
files #5, 6, and 7 are required as boundary conditions for the
model, other inputs, or for plotting.

The files are:
1. [NCEPLIBS container](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/20210224-ubuntu18-nceplibs.gz)
2. [config.sh](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/config.sh)
3. [run_all.sh](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/run_all.sh)
4. [ufs-srweather-app-Dockerfile](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/ufs-srweather-app-Dockerfile)
5. [fix_files.tar.gz](https://ufs-data.s3.amazonaws.com/public_release/ufs-srweather-app-v1.0.0/docker/fix_files.tar.gz)
6. [Native Earth files](https://ftp.emc.ncep.noaa.gov/EIB/UFS/SRW/v1p0/natural_earth/natural_earth_ufs-srw-release-v1.0.0.tar.gz)
7. [Model input data](https://ftp.emc.ncep.noaa.gov/EIB/UFS/SRW/v1p0/simple_test_case/gst_model_data.tar.gz)

Ensure that run_all.sh is given execute permissions.

## Step 2: Set environment variables

These environment variables are required for running the container
but not for building the container.  They are set here so when they
are referenced later in these instructions it is clear to what they
refer to. If you use `run_UFS_SRW_container.sh`, then these env
vars are automatically set for you.

```bash
export HOST_TEMP_DIR="/home/example_home_directory/ufs"
export DOCKER_TEMP_DIR=/tmp/docker
```

## Step 3: Unpack data for model run

To speed up Docker container build time and reduce the overall size
of the image, move the `fix_files` and `Model input data` into the
data directory that will be mounted into the Docker container BEFORE
running the Docker build.  Otherwise, these very large archives will
be by default inclued in the Docker build context which slows the
process down.  The decompression process takes a few minutes.
Slight modification from the instructions:

```bash
mkdir $HOST_TEMP_DIR
cd "$HOST_TEMP_DIR"
mv /path/to/model_data_fv3gfs_2019061500.tar.xz .
mv /path/to/fix_files.tar.xz .
mv /path/to/natural_earth_ufs-srw-release-v1.0.0.tar.gz .
tar -xvzf model_data_fv3gfs_2019061500.tar.xz
tar -xvzf fix_files.tar.xz
tar -xvzf natural_earth_ufs-srw-release-v1.0.0.tar.gz
```

One way to bypass this is to set the environment variable
[`DOCKER_BUILDKIT=1` or list these large files in `.dockerignore`](https://stackoverflow.com/questions/26600769/build-context-for-docker-image-very-large). 
However, since moving the files to `$HOST_TEMP_DIR` needs to be
done anyway, might as well do it now for simplicity.

## Step 4: Build Docker container

See `build_UFS_SRW_container.sh` for steps that import the downloaded
NCEPLIBS container (prebuilt) and build the Docker container.  If you
prefer to build your own NCEPLIBS container, the instructions are in
the [NCEPLIBS-external documentation](https://github.com/NOAA-EMC/NCEPLIBS-external/blob/ufs-v2.0.0/doc/README_ubuntu_gnu.txt). The container build takes a few minutes to run.

If you separate the container import and build steps,
you can move `20210224-ubuntu18-nceplibs.gz` to somewhere
else and still import it into the local Docker container
registry.  Then, this file does not get included in the
build context either, further speeding up build time.

## Step 5: Run the Docker container

**WARNING:**  If you have shut down your instance, you will need to
reset the environment variables in Step 2.  They are automatically
set in `run_UFS_SRW_container.sh`.

The script `run_UFS_SRW_container.sh` was setup to simplify the run
process by starting the container and then sending `config.sh` for
a particular run and all the commands necessary to set up the run
environment in the container and run the model with `demo_script.sh`.
To specify which `config.sh` you want to run with:
```bash
./run_UFS_SRW_container.sh config.sh
``

## Step 6: Monitor and postprocess and visualize the runs.

See RUN_MONITORING.md in the top level directory since this
applies to output with and without containers.

## Step 7: Managing containers

It appears that the UFS SRW compiled code may be sensitive
to the number of cores that the code was compiled on. For
example, compiling on a 16 CPU machine  and using the default
12 CPU and 4CPU settings seems to work without changing the
container.  On the other hand, trying to run that same container
on a larger machine results in memmory/bus errors.  For now,
tag the containers based on the the number of CPU used
to compile them, e.g.:
```bash
docker image tag <image_id> parallelworks/ufs-srweather-demo:v1.32cpu
```
The v1 referes to the UFS-SRW version number.

## Singularity containers

While it is straightforward to use
```bash
singularity pull singularity pull docker://parallelworks/ufs-srweather-demo:v1.32cpu
```
to convert a Docker container on DockerHub to a Singularity container,
the Singularity container will need to be set up as an editable
sandbox in order to run UFS SRW because there are several files
within the container file system that need to be modified in order
to build and run the default UFS SRW workflow.  For now, stick with
a Docker container.
