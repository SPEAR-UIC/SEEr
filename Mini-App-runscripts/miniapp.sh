#!/bin/bash
source /etc/profile.d/z00_lmod.sh

# make sure to note the mini app parameters before running the test
# run this from a ThetaGPU service node

# set up environment
module load openmpi/openmpi-4.1.4_ucx-1.12.1_gcc-9.4.0
module load conda/2021-11-30
conda activate
source /lus/grand/projects/SEEr-planning/miniapp_env/bin/activate
cd /lus/grand/projects/SEEr-planning/Miniapps/miniappA

# compile
source setup.sh

# run the mini app
mpirun -np 2 ./app --device gpu # ./app probably works just as well
                                # but horovodrun didn't work for some reason
#mpirun -x LD_LIBRARY_PATH -hostfile $COBALT_NODEFILE -n 8 -npernode 8 ./app --device gpu
