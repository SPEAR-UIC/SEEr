#!/bin/sh
#PBS -A SEEr-Polaris
#PBS -l select=10
#PBS -l walltime=1:00:00
#PBS -l filesystems=grand
#PBS -l place=exclhost

# set up the environment
module load conda
conda activate

# navigate to the specified miniapp size
#cd /lus/grand/projects/SEEr-Polaris/Polaris-Miniapps/miniapp_A/app_build # uncomment for size A
#cd /lus/grand/projects/SEEr-Polaris/Polaris-Miniapps/miniapp_B/app_build # uncomment for size B
#cd /lus/grand/projects/SEEr-Polaris/Polaris-Miniapps/miniapp_S/app_build # uncomment for size S
#cd /lus/grand/projects/SEEr-Polaris/Polaris-Miniapps/miniapp_M/app_build # uncomment for size M
cd /lus/grand/projects/SEEr-Polaris/Polaris-Miniapps/miniapp_L/app_build # uncomment for size L
#cd /lus/grand/projects/SEEr-Polaris/Polaris-Miniapps/miniapp_C/app_build # uncomment for size C

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
N=tex_cache_hit_rate
O=tex_cache_transactions

# two metrics
#time ncu --metrics $F --csv -o metric_F_size_S_polaris ./app
# time ./app
time nsys profile --gpu-metrics-device=all -o nsys_size_L_polaris ./app
