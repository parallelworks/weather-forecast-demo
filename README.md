# weather-forecast-demo
Demonstration of weather forecast model running in the cloud.

1. containers - how to build and use the Docker and Singularity containers used in this demo.
2. workflow - workflow orchestration files/docs for running the demo via PW
3. vis - visualization tools to postprocess demo output (in addition to default built-in postproc plotting)

An alternative to using containers is to directly install
the UFS-SRW and dependencies onto a worker image.  This is
useful if setting up a "tradiational" cluster environment
and documented in `running_ufs_demo_without_docker.md`.

## To do

Where can we get near-real time data for initializing our own forecasts?
Some possible leads are:
1. The [NOMADS](https://nomads.ncep.noaa.gov/pub/data/nccf/com/) link from
the [UFS SRW documentation](https://ufs-srweather-app.readthedocs.io/en/ufs-v1.0.1/InputOutputFiles.html).  However, this site appears to be an old link.

2. This [other NOMADS](https://para-nomads-cprk.ncep.noaa.gov/) site may be
a short-term replacement for system upgrades, etc.?  On the site, it seems that
the [production link](https://para-nomads-cprk.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/) is the most viable GEFS link.  There are also links to RAP and HRRR data but they are currently broken.

For example, for April 19 2022 00 data, which goes in 2022041900/ICS,
wget https://para-nomads-cprk.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.20220419/00/atmos/gfs.t00z.pgrb2.0p25.f000

Then, for the LBCS,
wget https://para-nomads-cprk.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.20220419/00/atmos/gfs.t00z.pgrb2.0p25.f006
wget https://para-nomads-cprk.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.20220419/00/atmos/gfs.t00z.pgrb2.0p25.f012
...

(Each of the three files' downloads takes about 2 mins on a GCE worker node,
~500MB per file.)

Finally, set up symbolic links.  I don't know if this is done automatically
or not, but I will do this for now. This was executed in 2022401900.

ln -sv ICS/gfs.t00z.pgrb2.0p25.f000 gfs.pgrb2.0p25.f000
ln -sv LBCS/gfs.t00z.pgrb2.0p25.f006 gfs.pgrb2.0p25.f006
ln -sv LBCS/gfs.t00z.pgrb2.0p25.f012 gfs.pgrb2.0p25.f012

Let's setup a manually run script to copy the data to a GCE bucket and we'll
mount the bucket.  Then, allow for the "stock" data in the bucket and then
manually add up-to-date data in the bucket so we can run today's forecast
from the bucket.  This minimizes download requests to NOAA which are
probably slower than bucket requests.
