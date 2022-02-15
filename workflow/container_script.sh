#!/bin/bash
#==========================
# This script automates the
# steps *inside* the container
# that run a demo forecast.
#==========================

# Inputs
run_config=$1

echo "==============================="
echo Starting container script...
echo Starting at: `pwd`
echo Container script has access to:
ls -alh
echo Run config: $run_config
echo Container set `env | grep DOCKER_TEMP_DIR`
echo Container set `env | grep EXPTDIR`
echo Container set `env | grep LOG_DIR`
echo "==============================="

# Tell the workflow where
# to write output (this
# is the base directory
# that is actually a directory
# from the host that is mounted
# in the container).
#export DOCKER_TEMP_DIR="/tmp/docker"
# NOT NEEDED - done with docker run --env

# Overwrite the config.sh included in the
# container with user specified config
mv -vf $run_config /usr/local/src/ufs-srweather-app/regional_workflow/ush/config.sh

# Build the workflow
echo Building the workflow...
cd /usr/local/src/ufs-srweather-app/regional_workflow/ush
./generate_FV3LAM_wflow.sh

# Fix a permission issue with the generated workflow script
# and run the workflow.
cd wrappers/

# The critical EXPTDIR variable in run_all.sh is not synced
# with the same value specified in config.sh.  This can
# result in strange things (like sending the wrong config
# to the run because it's reading the config from the
# wrong directory.  This is an issue particularly if you have
# multiple runs.  To fix this, grab EXPT_BASEDIR and
# EXPT_SUBDIR from config.sh, cat them to EXPTDIR,
# and set it as an environment variable here.  The
# extra eval is needed so that any variables in
# config.sh are also derferenced (e.g. DOCKER_TEMP_DIR).
# Then, remove the EXPTDIR line from run_all.sh.
# The final set of back ticks creates a random string
# ending for EXPTDIR to allow for fully parallel runs
# on the same file system.
# This line of code was executed within the Docker
# container, but for the purposes of workflow tracking,
# we need to know the random string, so
# this will be executed by the setup script and passed
# as an environment variable via docker run --env when
# running this container script.
#eval export EXPTDIR=`grep EXPT_BASEDIR ../config.sh | awk -F= '{print $2}' | tr -d \"`/`grep EXPT_SUBDIR ../config.sh | awk -F= '{print $2}' | tr -d \"

echo "======================"
echo Container set `env | grep EXPTDIR`
echo Container set `env | grep LOG_DIR`
echo "======================"

mv run_all.sh run_all.sh.bkup
grep -v EXPTDIR= run_all.sh.bkup | grep -v LOG_DIR= > run_all.sh
chmod u+x run_all.sh

# For interactive runs
#./run_all.sh > run_all.log 2>&1 &
#tail -f run_all.log

# For automated runs
./run_all.sh 2>&1
