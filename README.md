# Mini-App

## What is the Mini-App?
This is a demo of a PDE solver using in-situ data analysis. The C++ part of the application, `app.cpp`, runs on the CPU, and it communicates with the the Python part, `app_build/python_module.py`, which runs on the GPU.

## Setting up the Mini-App
1. Request an interactive node on either ThetaGPU or Polaris.

2. Load the Conda module and activate it.

    - `$ module load conda`

    - `$ conda activate`

3. Navigate into the Mini-App of your prefered machine and problem size.

4. Run `$ source setup.sh `

    - This will compile the Mini-App and automatically change directories into `app_build`.
 
5. The Mini-App may now be simply run with `$ ./app`.

## Using the Mini-App job script: Polaris

1. Set the PBS job scheduler parameters at the top of the script.

2. Modify the script to load the prefered version of Conda module.

3. Edit the paths to various sizes so that they point to where they live in your directory.

4. Comment out all paths except the one for the prefered problem size.

5. Uncomment the preferred data collection command.

    a. `time ./app` will time an uninstrumented run of the Mini-App.
    
    b. `time ncu --metrics $E,$F --csv -o metric_EF_size_S_polaris ./app` will time a run of Nsight Compute which profiles the Mini-App for metrics E and F and puts the data into a file titled "metric_EF_size_S_polaris.ncu-rep".
    
    c. `time nsys profile --gpu-metrics-device=all -o nsys_size_L_polaris ./app` will time a run of Nsight Systems which profiles the Mini-App and puts the data into a file titled "nsys_size_L_polaris".
    
    Note that it is recommended to only submit the script with one of these commands at a time.
    
6. Edit the data collection command to specify the prefered metrics and select a descriptive and appropriate output name.

7. Submit the script to Polaris.

    - `$ qsub -q prod ./miniapp_polaris.sh`
    
## Using the Mini-App job script: ThetaGPU

1. The two `source` commands at the top ensure that the `module` and data collection commands have access to the appropriate executable.

2. Modify the script to load the prefered version of Conda module.

3. Uncomment `export CUDA_VISIBLE_DEVICES=` to disable access to all GPUs in the system and collect data for a CPU-only run.

4. Edit the paths to various sizes so that they point to where they live in your directory.

5. Comment out all paths except the one for the prefered problem size.

6. Uncomment the preferred data collection command.

    a. `time ./app` will time an uninstrumented run of the Mini-App.
    
    b. `time ncu --metrics $E,$F --csv -o metric_EF_size_S_polaris ./app` will time a run of Nsight Compute which profiles the Mini-App for metrics E and F and puts the data into a file titled "metric_EF_size_S_polaris.ncu-rep".
    
    c. `time nsys profile --gpu-metrics-device=all -o nsys_size_L_polaris ./app` will time a run of Nsight Systems which profiles the Mini-App and puts the data into a file titled "nsys_size_L_polaris".
    
    Note that it is recommended to only submit the script with one of these commands at a time.
    
7. Edit the data collection command to specify the prefered metrics and select a descriptive and appropriate output name.

7. Submit the script to ThetaGPU. For example,

    - `$ qsub -n 1 -A SEEr-planning -q full-node --attrs=filesystems=home,grand,theta-fs0:perf=true -t 2:00:00 ./miniapp_thetagpu.sh`
    
## Changing the problem size of the Mini-App
This repository contains all six sizes of the Mini-App, configured both for Polaris and ThetaGPU. However, if one wishes to explore sizes of the Mini-App other than these, here are the directions to do so.

The Mini-App, when it was included as part of the SDL AI Workshop, was written with only one size in mind, which is now called size A. Dr. Romit Maulik is very familiar with this application, so he gave direction on what shall be modified to get a new problem size.

The size of the problem handled by the Mini-App is determined by the NX parameter, on line 13 in `app.cpp`. By default, this is 256. To avoid crashes, this should always be a multiple of 256 when modified. However, once NX starts to grow, DT must be modified as well. DT, on line 14, is initially 0.001, but should be divided by 10 (decrease the time step by a factor of 10), when NX grows much larger. Therefore, NX and DT must be modified in tandem to maintain stability amidst problem size growth.

Once NX (and perhaps DT) is changed in `app.cpp`, one must update `app_build/python_module.py` accordingly. On line 14, the shape of `data_array` must change in accordance with NX and DT. The first parameter, which is by default 2001, must grow by the same factor at DT. For example, if DT is changed to 0.0001, then 2001 becomes 20001. The second parameter becomes NX+2 (to account for endpoints). So if NX is changed to 512, then this becomes 514. Lastly, the `step` parameter on line 15 must be scaled by the same NX value. By default it is divided by 256, so changing NX to 512 also changes this to 512.

Once these changes to NX and DT are made in `app.cpp` and are appropriately reflected in `app_build/python_module.py`, then `source setup.sh` must be run again to re-compile.

Here are the parameters for the existing sizes. Note that size D is the same as size S; size E is the same as size M; and size F is the same as size L.

| Size | NX   | DT      |
|------|------|---------|
| A    | 256  | 0.001   |
| B    | 512  | 0.001   |
| C    | 1280 | 0.001   |
| D/S  | 2560 | 0.0001  |
| E/M  | 3840 | 0.0001  |
| F/L  | 5120 | 0.00001 |

## I get a SIGABRT/Error 6/Free(): Error after executing the Mini-App. What happened?
This is to be expected and does not affect the actual performance of the Mini-App. It is okay. It is a consequence of adding Horovod functionality to the Mini-App. The original Mini-App was written to run on a single GPU. However, one can use Horovod to extend a Python application to multiple GPUs. However, calling `horovod.init()` in a Python application that is started from C++ code causes this double-free issue after the `return 0` of the C++ part of the application.

Since the C++ part is not yet equipped to handle multiple GPUs, the Horovod functionality that was added to `app_build/ml_module.py` does not do anything right now. To avoid this error on exit, the original, non-Horovod, single GPU version of `app_build/ml_module.py` is still included as `ml_module.py.original`. Just copy this to `ml_module.py` to use it. The current `ml_module.py` matches the included `ml_module.py.horovod` for easy switching between the Horovod and non-Horovod versions of the Python part of the Mini-App. 

## Porting the Mini-App to a new machine
Mostly likely just `CMakeLists.txt` will need to be updated. It should point to the location of the necessary libraries on the new system and agree with the version of Conda module that will be loaded in the job script.
