# Notes on monitoring runs

Read this file after ./container/README.md or
./direct_install/README.md (general setup and running notes).

Peak RAM usage on LINUX for 25km grid: 18GB

## Run scoping

Config.sh is where the number of CPU is set along with key run
parameters (i.e. length of forecast).  This file can be modified
before building the container OR after the container is built and
modified before the workflow is generated.  E.g. I first built the
container for a 12 CPU, 48 hour forecast, but then I changed the
forecast length and reducted CPUs to 4 in:
`/usr/local/src/ufs-srweather-app/regional_workflow/ush/config.sh`
which is where the config.sh that gets included into the container
appears to end up.  So, in summary, you can change the run
specifications on-the-fly without having to rebuild the container.

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

A 48 hour forecast will output 11G of data in `experiment`
(including postproc)and 16M of logs in `log`.

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

Can't run 6 hour?  Try afresh.

Workflow crashes in plotting:
(due to not putting natural_earth in $DOCKER_TEMP_DIR
b/c not listed in instructions) probably cleared up now.

Traceback (most recent call last):
  File "./plot_allvars.py", line 804, in <module>
    main()
  File "./plot_allvars.py", line 400, in main
    plot_all(dom)
  File "./plot_allvars.py", line 467, in plot_all
    img = plt.imread(CARTOPY_DIR+'/raster_files/NE1_50M_SR_W.tif')
  File "/usr/local/lib/python3.6/dist-packages/matplotlib/pyplot.py", line
 2246, in imread
    return matplotlib.image.imread(fname, format)
  File "/usr/local/lib/python3.6/dist-packages/matplotlib/image.py", line 
1496, in imread
    with img_open(fname) as image:
  File "/usr/local/lib/python3.6/dist-packages/PIL/Image.py", line 2904, i
n open
    fp = builtins.open(filename, "rb")
FileNotFoundError: [Errno 2] No such file or directory: '/tmp/docker/natur
al_earth/raster_files/NE1_50M_SR_W.tif'