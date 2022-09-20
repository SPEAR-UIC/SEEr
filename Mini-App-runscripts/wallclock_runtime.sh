#!/bin/bash


#cd /lus/grand/projects/SEEr-planning/Miniapps/miniappF/app_build # uninstrumented
cd /lus/grand/projects/SEEr-planning/mantis-monitor/src # instrumented

echo $(date)
#mpirun -np 1 ./app --device gpu # uninstrumented
python3 monitor.py ../new_miniapp.yaml # instrumented
echo $(date)
