# Notes on monitoring runs

Read this file after ./container/README.md or
./direct_install/README.md (general setup and running notes).

## Hardware requirements:

04 CPU is recommended minimum
04 CPU results for low res -> ~1 hour for 6 hour forecast
12 CPU results in ->
32 CPU (not all used) ->

The larger cores are faster than linear speedup
b/c disk I/O speeds up too on GCE and I/O requirements
can be substantial.

Peak RAM usage for 25km grid: 20GB (preproc), forecast RAM ~3GB.
Peak RAM usage for 03km grid: 43GB (preproc), forecast could be 100x.

6 hour, low res (25km) forecast: ~5GB stored output


## Run scoping

Config.sh is where the number of CPU is set along with key run
parameters (i.e. length of forecast).  This file can be modified
before building the container OR after the container is built and
modified before the workflow is generated.  E.g. I first built the
container for a 12 CPU, 48 hour forecast, but then I changed the
forecast length and reducted CPUs to 4 in:
`/usr/local/src/ufs-srweather-app/regional_workflow/ush/config.sh`
which is where the config.sh that gets included into the container
appears to end up.

In general, it appears that a container built with N CPU cannot
run with more than N CPU, even if we copy the container to a new
computer with more than N CPU and we tell mpirun to use more than
N cores.  We can, however, use a container that is built on M CPU
and run with N < M CPU.  The complicating factor is that the
model domain decomposition (which sets the number of MPI
processes and CPU that can be used) must be set very carefully.

## Data management

The fix_* and model_input directories created during
the general setup stage are only read.
Two new directories are automatically added in the
`ufs` directory when the
workflow is run:
1. log
2. experiment

The outputs and most logs from the forecast go to
$DOCKER_TEMP_DIR, which is usually /tmp/docker in
the container and /home/<user>/ufs/experiment/test_CONUS_25km_GFSv15p2/
on the host machine.  Note that the last directory
name is the EXPT_SUBDIR set in config.sh and also
**hard coded** in a variety of places in run_all.sh.

A 48 hour forecast on the 25km grid will output
11G of data in `experiment` (including postproc)
and 16M of logs in `log`.

A 6 hour forecast on the 25km grid will output
5GB of data in `experiment`.  With 4 CPU, it
takes 35 minutes to run end-to-end, about 7-9
minutes with 32 CPU.  In the 32 CPU case,
only 12 CPU are being used, but you get a
more than 2x faster bandwidth to local persistent
disk when you go from 31 to 32 cpu.  In a test
with 

## Preprocessing, run setup, and overview

The first two minutes or so are slow data copying steps that
do not use all resources. Afterwards, 12 CPU (which were spec'ed
in config.sh) are generally well utilized.  Initial
workflow steps (25km grid) use 1-5GB RAM except for surface
climatology fields that will peak up to 18GB RAM.
Forecast running on 25km grid takes ~4GB RAM.
With 12 CPU, each forecast hour takes about 1 minute.  This
rate of run is roughly constant over the forecast and
can be determined by `ls -alh experiment/test_CONUS_25km_GFSv15p2/20190615
00/logf*`
With 4 CPU, each forecast hour takes about 2 minutes on a machine with
more than 4CPU!  On a 16CPU machine, I can see the 4CPUs crunching but
there is also a 100% 5th CPU that I think is taking care of system/MPI
background processes.  So on a 4CPU only machine, forecast hours will
take longer.


## Details about monitoring logs

Current progress in workflow steps is obtained by tail on main log:
```bash
tail /usr/local/src/ufs-srweather-app/regional_workflow/ush/wrappers/run_all.log
```

The listing of log files by time is a nice way to check
run time of each workflow step:
```bash
ls -ltr --full-time $DOCKER_TEMP_DIR/log/
```

## Postprocessing and plotting

Post processing uses all allocated codes (i.e. 12) at about 60-70% with minimal RAM (1GB).
Plotting in Python uses only a single core at 100% and minimal RAM.

## ERRORS

Bus errors and major memory issues when taking a container built with 12 CPU and just changing to 64CPU after reboot on a bigger machine. The possible problems are: bad config change, need to restructure app, need to rebuild container for more CPU.