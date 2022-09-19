#!/bin/bash
#COBALT -n 1 -A Seer-Planning
#COBALT --attrs perf=true:fakeroot=true

source /etc/profile.d/z00_lmod.sh
source /lus/grand/projects/SEEr-planning/spack/share/spack/setup-env.sh
module load openfoam-org-8-gcc-9.3.0-6taoysc
module load conda/2021-11-30
conda activate
source /lus/grand/projects/SEEr-planning/PythonFOAM/prep_env.sh

# for single-gpu multiple-tensorflow
export TF_FORCE_GPU_ALLOW_GROWTH=true

python3 aefoam.py ~/mantis-aefoam.yaml
