#!/bin/bash

source /etc/profile.d/z00_lmod.sh
source /etc/profile.d/nv_paths.sh

module load conda/2021-11-30
conda activate

# uncomment this line to switch to CPU-only
#export CUDA_VISIBLE_DEVICES=

# navigate to the specified miniapp size
#cd /lus/grand/projects/SEEr-Polaris/Miniapps/miniappD/app_build # uncomment for size S
#cd /lus/grand/projects/SEEr-Polaris/Miniapps/miniappE/app_build # uncomment for size M
#cd /lus/grand/projects/SEEr-Polaris/Miniapps/miniappF/app_build # uncomment for size L
#cd /lus/grand/projects/SEEr-Polaris/Miniapps/miniappC/app_build # uncomment for size C
cd /lus/grand/projects/SEEr-Polaris/Miniapps/miniappA/app_build # uncomment for size A

# time info gets printed to stderr

# no metric
#time ./app

# set up variables for the NCU metrics that we are interested in
A=l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum
B=l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum
C=l1tex__data_pipe_lsu_wavefronts_mem_shared_op_ld.sum
D=l1tex__data_pipe_lsu_wavefronts_mem_shared_op_st.sum
E=smsp__inst_executed_op_shared_ld.sum
F=smsp__inst_executed_op_shared_st.sum
G=smsp__sass_thread_inst_executed_op_control_pred_on.sum
H=smsp__sass_thread_inst_executed_op_integer_pred_on.sum
I=smsp__sass_thread_inst_executed_op_memory_pred_on.sum
J=smsp__sass_thread_inst_executed_op_misc_pred_on.sum
K=smsp__inst_executed.sum
L=smsp__inst_executed_op_global_ld.sum
M=smsp__inst_executed_op_global_st.sum
#N=tex_cache_hit_rate
#O=tex_cache_transactions

# two metrics
time ncu --sampling-max-passes 3 --metrics $K,$L,$M --csv -f -o metric_KLM_size_A_thetagpu ./app
