#! /bin/bash

set -ue # abort if a variable is empty (u) or a command fails (e)

# Next line sets the directory for log files; script fails here if you
# forget to set DOCKER_TEMP_DIR:
LOG_DIR="$DOCKER_TEMP_DIR/log"

# This block aborts if the machine has fewer than 4 CPUs.
# The scripts will still run with fewer CPUs, but they'll be very slow.
nprocs=$( grep -E 'processor[[:space:]]*:' /proc/cpuinfo|wc -l )
if (( nprocs < 4 )) ; then
    echo ERROR: This Docker container requires a machine with 4 CPUs.
    echo Disable this check to run anyway. It may be very slow.

    # Comment out the next line ("exit 2") to run with fewer than 4 CPUs
    exit 2
fi

# Be wordy:
echo Running all steps.
echo Will log to "$LOG_DIR"

set -x  # Be even more wordy.

# Make the log directory if it doesn't exist:
[ -d "$LOG_DIR" ] || mkdir "$LOG_DIR"

# This next line disables threading, ensuring the machine is not
# overcommitted.
export OMP_NUM_THREADS=1

# Fortran programs use massive amounts of stack, so this next line
# disables all stack limits.
ulimit -s unlimited

# If ulimit -s unlimited fails due to host system settings, replace it
# with this line, which sets the limit to about 6 GB:
# ulimit -s 6000000

# All run_ scripts assume this variable is set:
# This is also set in config_defaults.sh,
# which is read when the workflow is generated
# but somehow not propagated into the environment.
# This can result in a different directory than
# what the user espects as defined in config.sh!
export EXPTDIR=$DOCKER_TEMP_DIR/experiment/test_CONUS_25km_GFSv15p2

########################################################################

# Next, we run each step.

# Warning: The scripts don't have spectacular error checking, so they
# may continue to the next step if a step fails. The tail -20 command
# prints the last 20 lines of the log file, to assist in
# debugging. The full log is in the $LOG_DIR.

nohup ./run_get_ics.sh > "$LOG_DIR/get_ics.log" 2>&1
tail -20 "$LOG_DIR/get_ics.log"

nohup ./run_get_lbcs.sh > "$LOG_DIR/get_lbcs.log" 2>&1
tail -20 "$LOG_DIR/get_lbcs.log"

nohup ./run_make_grid.sh > "$LOG_DIR/make_grid.log" 2>&1
tail -20 "$LOG_DIR/make_grid.log"

nohup ./run_make_orog.sh > "$LOG_DIR/make_orog.log" 2>&1
tail -20 "$LOG_DIR/make_orog.log"

nohup ./run_make_sfc_climo.sh > "$LOG_DIR/make_sfc_climo.log" 2>&1
tail -20 "$LOG_DIR/make_sfc_climo.log"

nohup ./run_make_ics.sh > "$LOG_DIR/make_ics.log" 2>&1
tail -20 "$LOG_DIR/make_ics.log"

nohup ./run_make_lbcs.sh > "$LOG_DIR/make_lbcs.log" 2>&1
tail -20 "$LOG_DIR/make_lbcs.log"

echo Running the forecast. This may take a long time.
nohup ./run_fcst.sh > "$LOG_DIR/fcst.log" 2>&1
tail -20 "$LOG_DIR/fcst.log"

# Check for the last two files in the 48 hour forecast. This ensures
# the model has finished before we run the post.
#ls -l $EXPTDIR/2019061500/dynf048.nc
#ls -l $EXPTDIR/2019061500/phyf048.nc
# Shorten check from 48h to 6h forecast
ls -l $EXPTDIR/2019061500/dynf006.nc
ls -l $EXPTDIR/2019061500/phyf006.nc

echo Forecast completed. Running the post.
nohup ./run_post.sh > "$LOG_DIR/post.log" 2>&1
tail -20 "$LOG_DIR/post.log"

echo Plotting data. This could take a while.
cd ../Python
#python3 ./plot_allvars.py 2019061500 6 48 6 \
#        $DOCKER_TEMP_DIR/experiment/test_CONUS_25km_GFSv15p2/ \
#        $DOCKER_TEMP_DIR/natural_earth
# Shorten plotting from 48h to 6h forecast
python3 ./plot_allvars.py 2019061500 6 6 6 \
        $DOCKER_TEMP_DIR/experiment/test_CONUS_25km_GFSv15p2/ \
        $DOCKER_TEMP_DIR/natural_earth
# Make sure at least one plot exists:
ls -1 $DOCKER_TEMP_DIR/experiment/test_CONUS_25km_GFSv15p2/2019061500/postprd/*.png > /dev/null

set +x
echo
echo Done.
echo
echo The model ran here:
echo "  " $DOCKER_TEMP_DIR/experiment/test_CONUS_25km_GFSv15p2/2019061500
echo
echo GRIB2 files and plots are in the postprd subdirectory:
echo "  " $DOCKER_TEMP_DIR/experiment/test_CONUS_25km_GFSv15p2/2019061500/postprd
echo
echo Enjoy.

########################################################################

# Implementation Notes.

# If a step fails, and you want to rerun it, you can comment out the
# previous steps so they aren't rerun.

# The "tail -20" after each step prints the last 20 lines of the log
# file. If there is an error, you may have to read the rest of the log
# file to debug.

# The make_sfc_climo is the first step that runs MPI.  If you set up
# everything correctly, but you're running into hardware or OS
# limitations, that is likely the first step to fail.  Low memory
# machines may fail earlier, depending on how little memory you have.

# The nohup command is a workaround for a bug in mpiexec.hydra.
# It tries to read from the terminal every time it starts a program.
# The "nohup" command (mostly) disconnects the program from the terminal.

# To recompile, you need to load many modulefiles, set some
# environment variables, and run the scn command. You do not need to
# do that to run the model.
