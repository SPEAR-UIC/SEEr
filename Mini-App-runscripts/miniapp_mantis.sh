#!/bin/bash

source /etc/profile.d/z00_lmod.sh

module load conda
conda activate
source /lus/grand/projects/SEEr-planning/miniapp_env/bin/activate

cd /lus/grand/projects/SEEr-planning/mantis-monitor/src
# uncomment this line to switch to CPU-only
#export CUDA_VISIBLE_DEVICES=
python3 monitor.py ../new_miniapp.yaml
