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

# Build the workflow
cd /usr/local/src/ufs-srweather-app/regional_workflow/ush
./generate_FV3LAM_wflow.sh

# Fix a permission issue with the generated workflow script
# and run the workflow.
cd wrappers/
chmod u+x run_all.sh
./run_all.sh > run_all.log 2>&1 &
tail -f run_all.log
