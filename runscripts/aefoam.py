"""
This code is licensed under LGPL v 2.1
See LICENSE for details
"""

import mantis_monitor
import subprocess
import os

class AEFoam(mantis_monitor.benchmark.benchmark.Benchmark):
    cwd = '/lus/grand/projects/SEEr-planning/PythonFOAM/Solver_Examples/AEFoam/Run_Case'
    env = None # don't overwrite externally-set env vars

    @classmethod
    def generate_benchmarks(cls, arguments):
        return [cls({'gpu_count': gpu_count}) for gpu_count in arguments['gpu_counts']]

    def before_each(self):
        print(f'Starting run with {self.gpu_count} GPUs')
        os.environ['CUDA_VISIBLE_DEVICES'] = ','.join(str(i) for i in range(self.gpu_count)) # os.putenv doesn't update os.environ
        print('Cleaning output', flush=True)
        subprocess.run('rm *.h5', shell=True, cwd=self.cwd)
        subprocess.run("find . -maxdepth 1 -regex '\./\([1-9][0-9]*\|[0-9][0-9]*\.[0-9][0-9]*\)' -exec rm -r {} \;", shell=True, cwd=self.cwd)
        subprocess.run('rm -r processor*', shell=True, cwd=self.cwd)
        print('Decomposing mesh')
        subprocess.run('decomposePar', shell=True, cwd=self.cwd)

    def get_run_command(self):
        return f'mpiexec -np 2 ~/OpenFOAM/hgreenbl-8/platforms/linux64GccDPInt32-spack/bin/AEFoam -parallel'

    def __init__(self, arguments):
        self.gpu_count = arguments['gpu_count']
        self.name = f'AEFoam_{self.gpu_count}'

mantis_monitor.monitor.run_with(AEFoam)
