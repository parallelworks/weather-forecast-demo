MACHINE=LINUX
ACCOUNT="an_account"
EXPT_BASEDIR=$DOCKER_TEMP_DIR/experiment
EXPT_SUBDIR="test9_CONUS_25km_GFSv15p2"

VERBOSE="TRUE"

RUN_ENVIR="community"
PREEXISTING_DIR_METHOD="rename"

STMP=$DOCKER_TEMP_DIR/stmp
PTMP=$DOCKER_TEMP_DIR/ptmp

PREDEF_GRID_NAME="RRFS_CONUS_25km"
GRID_GEN_METHOD="ESGgrid"
QUILTING="TRUE"
CCPP_PHYS_SUITE="FV3_GFS_v15p2"
#FCST_LEN_HRS="48"
# Shorten forecast length from 48h to 6h.
FCST_LEN_HRS="6"
LBC_SPEC_INTVL_HRS="6"

TOPO_DIR=$DOCKER_TEMP_DIR/fix_orog
SFC_CLIMO_INPUT_DIR=$DOCKER_TEMP_DIR/fix_sfc_climo

DATE_FIRST_CYCL="20190615"
DATE_LAST_CYCL="20190615"
CYCL_HRS=( "00" )

EXTRN_MDL_NAME_ICS="FV3GFS"
EXTRN_MDL_NAME_LBCS="FV3GFS"

FV3GFS_FILE_FMT_ICS="grib2"
FV3GFS_FILE_FMT_LBCS="grib2"

WTIME_RUN_FCST="01:00:00"

#
# Uncomment the following line in order to use user-staged external model 
# files with locations and names as specified by EXTRN_MDL_SOURCE_BASEDIR_ICS/
# LBCS and EXTRN_MDL_FILES_ICS/LBCS.
#
USE_USER_STAGED_EXTRN_FILES="TRUE"
#
# The following is specifically for Hera.  It will have to be modified
# if on another platform, using other dates, other external models, etc.
#
EXTRN_MDL_SOURCE_BASEDIR_ICS="$DOCKER_TEMP_DIR/model_data/FV3GFS"
EXTRN_MDL_FILES_ICS=( "gfs.pgrb2.0p25.f000" )
EXTRN_MDL_SOURCE_BASEDIR_LBCS="$DOCKER_TEMP_DIR/model_data/FV3GFS"
EXTRN_MDL_FILES_LBCS=( "gfs.pgrb2.0p25.f006" "gfs.pgrb2.0p25.f012" "gfs.pgrb2.0p25.f018" "gfs.pgrb2.0p25.f024" \
                       "gfs.pgrb2.0p25.f030" "gfs.pgrb2.0p25.f036" "gfs.pgrb2.0p25.f042" "gfs.pgrb2.0p25.f048" )
FIXgsm=$DOCKER_TEMP_DIR/fix_am

RUN_CMD_FCST="mpirun -np \${PE_MEMBER01}"

# Twelve (12) core machines
RUN_CMD_UTILS="mpirun -np 12"
RUN_CMD_POST="mpirun -np 12"

# 32 core machine testing
# There are several issues at
# play including input tile files
# are already set to a certain
# domain decomp.
#RUN_CMD_UTILS="mpirun -np 32"
#RUN_CMD_POST="mpirun -np 32"
#LAYOUT_X="5"
#LAYOUT_Y="4"

# Comment out the next five lines if you want the 12 core settings
# Four (4) core machines
LAYOUT_X="1"
LAYOUT_Y="3"
RUN_CMD_UTILS="mpirun -np 4"
RUN_CMD_POST="mpirun -np 4"
