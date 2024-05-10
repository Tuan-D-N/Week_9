

for i in range(6):
    threads = 2**i
    fileName = f'Run{threads}'
    file = open(fileName, 'w', encoding='utf-8')

    file.write(f"""#!/bin/bash -l

#SBATCH --job-name=submit_monitor
#SBATCH --account=coursesuwashpc
#SBATCH --partition=work
#SBATCH --ntasks={threads}
#SBATCH --ntasks-per-node={threads}
#SBATCH --cpus-per-task=1
#SBATCH --time=00:03:00
#SBATCH --output=slurm-{threads}.out

srun -n {threads} ./MonteCarloManyThread.out
      """)
    file.close()
