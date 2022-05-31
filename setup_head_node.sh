B#!/bin/bash
#================================
# Install miniconda right here
# (in pwd) as fast as possible to
# just run Parsl. Runs in 15 mins.
#===============================

# Latest, but also nearly 50% bigger.
#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#chmod u+x Miniconda3-latest-Linux-x86_64.sh
#./Miniconda3-latest-Linux-x86_64.sh

wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
chmod u+x Miniconda3-py39_4.9.2-Linux-x86_64.sh
./Miniconda3-py39_4.9.2-Linux-x86_64.sh

# Follow manual prompts (license, install location)

source miniconda3/etc/profile.d/conda.sh
conda create --name parsl_py39
conda activate parsl_py39

conda install requests
conda install ipykernel
conda install -c anaconda jinja2
conda install -c conda-forge parsl

# Grab model config, data setup, and container run
git clone https://github.com/parallelworks/weather-forecast-demo
