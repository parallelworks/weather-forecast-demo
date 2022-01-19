# Installing and Running UFS demo without docker
## Installing:
Follow the steps on this link to install NCEPLIBS-external on an Ubuntu 20.04 VM
- Skip lines 102 and 111: `git clone -b ufs-v2.0.0 --recursive https://github.com/ufs-community/ufs-weather-model` and `./build.sh 2>&1 | tee build.log`
- There is a bug when installing cartopy: `pip3 install cartopy`. Run this instead: 
`pip install cartopy==0.19.0.post1`
- Note that these steps are for ufs-v.2.0.0. Looks like the demo still works with this version but keep in mind that we may need to go through these steps but for version 1.1.0 or version 1.0.0 in an Ubuntu 18.04 VM

Follow steps on section 11.2 of the [docker instructions](https://ufs-srweather-app.readthedocs.io/en/ufs-v1.0.1/Docker.html)

Follow step 6 on section 11.3 of the [docker instructions](https://ufs-srweather-app.readthedocs.io/en/ufs-v1.0.1/Docker.html)
- Before running the command make sure that the permissions are set right for directory `/usr/local/src`: `sudo chown -R ubuntu:ubuntu /usr/local/src`
- `git clone --branch ufs-v1.0.1 https://github.com/ufs-community/ufs-srweather-app.git /usr/local/src/ufs-srweather-app`

## Running:
Run the following commands:
- `source /usr/local/NCEPLIBS-ufs-v2.0.0/bin/setenv_nceplibs.sh`
- `ulimit -s unlimited`
- `export CMAKE_Platform=linux.gnu`

Follow steps 8, 9, 10 and 11 on section 11.3 of the [docker instructions](https://ufs-srweather-app.readthedocs.io/en/ufs-v1.0.1/Docker.html)
- Note that the scripts `config.sh`, and `wrappers/run_all.sh` use the `DOCKER_TEMP_DIR` environmental variable! So we still need to define this variable (or change the code, which has not been explored)
- In step 8  `DOCKER_TEMP_DIR` and `HOST_TEMP_DIR` were both set to `/home/ubuntu/ufs`

Change the file `/usr/local/src/ufs-srweather-app/regional_workflow/ush/wrappers/run_all.sh` to run the script with `bash` instead of `sh`
- For example, change “nohup ./run_get_ics.sh” to “nohup bash ./run_get_ics.sh”. Repeat for all ./run_*.sh scripts.
- The reason for this is that the source command (`source ${GLOBAL_VAR_DEFNS_FP}`) is not working in sh, only works in bash.  

Follow the rest of the steps from step 4 on section 11.4 to the end of the [docker instructions](https://ufs-srweather-app.readthedocs.io/en/ufs-v1.0.1/Docker.html)