#!/bin/bash
 
nvidia-smi --query-gpu=timestamp,index,power.draw --loop-ms=1000 --format=csv > smi-out.csv &
PID=$!
./app
kill $PID
