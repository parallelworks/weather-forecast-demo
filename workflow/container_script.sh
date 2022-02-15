#!/bin/bash
#==========================
# This script automates the
# steps *inside* the container
# that run a demo forecast.
#==========================

# Tell the workflow where
# to write output (this
# is the base directory
# that is actually a directory
# from the host that is mounted
# in the container).
export DOCKER_TEMP_DIR="/tmp/docker"

# Overwrite the config.sh included in the
# container with user specified config.sh
mv -f $DOCKER_TEMP_DIR/config.sh /usr/local/src/ufs-srweather-app/regional_workflow/ush/config.sh

# Build the workflow
cd /usr/local/src/ufs-srweather-app/regional_workflow/ush
./generate_FV3LAM_wflow.sh

# Fix a permission issue with the generated workflow script
# and run the workflow.
cd wrappers/

# The critical EXPTDIR variable in run_all.sh is not synced
# with the same value specified in config.sh.  This can
# result in strange things (like sending the wrong config
# to the run because it's reading the config from the
# wrong directory.  This is an issue only if you have
# multiple runs.  To fix this, grab EXPT_BASEDIR and
# EXPT_SUBDIR from config.sh, cat them to EXPTDIR,
# and set it as an environment variable here.  The
# extra eval is needed so that any variables in
# config.sh are also derferenced (e.g. DOCKER_TEMP_DIR).
# Then, remove the EXPTDIR line from run_all.sh.
eval export EXPTDIR=`grep EXPT_BASEDIR ../config.sh | awk -F= '{print $2}' | tr -d \"`/`grep EXPT_SUBDIR ../config.sh | awk -F= '{print $2}' | tr -d \"`

echo "================="
echo Setting experiment dir to: $EXPTDIR
echo "================="

mv run_all.sh run_all.sh.bkup
grep -v EXPTDIR= run_all.sh.bkup > run_all.sh
chmod u+x run_all.sh

# For interactive runs
#./run_all.sh > run_all.log 2>&1 &
#tail -f run_all.log

# For automated runs
./run_all.sh 2>&1
