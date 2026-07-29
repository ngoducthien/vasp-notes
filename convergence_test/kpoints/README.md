# KPOINTS Convergence Test Guide

![KPOINTS convergence](kpoints_convergence.png "KPOINTS convergence")

### 1. Prerequisites
Ensure the following VASP input files are in your working directory:
* `POSCAR`, `POTCAR`, `INCAR`

Note: The value of ENCUT is determined from the ENCUT convergence test.

### 2. Configurations

Modify `run_kpoints.sh` to match your desired `KPOINTS` list and `VASP_CMD`:

```bash
# ==================== CONFIGURATION ====================
KPOINTS_LIST="4x4x4 6x6x6 8x8x8 10x10x10 12x12x12 14x14x14 16x16x16"
VASP_CMD="srun /bin/vasp_std_5.4.1"
```

### 3. Execution
Run the automated script to test various k-point meshes:

```bash
./run_kpoints.sh
````

Alternatively, you can submit it as a cluster/supercomputer job using a Slurm submission script:

For example:
````
#!/bin/bash
#SBATCH -J vasp
#SBATCH -p qM                     # Job class
#SBATCH -n 128                    # Number of MPI processes
#SBATCH -c 1                      # Number of threads per MPI process
#SBATCH -o slurm-%j.out           # Standard Output file
#SBATCH -e slurm-%j.err           # Standard Error file
#SBATCH -t 47:30:00               # Time limit

module load inteloneapi/2023.2.0
module load intel-mpi/2021.16

date
sh run_kpoints.sh > output.log 2>&1
date
````

This will automatically loop through the `KPOINTS` list, run VASP for each value, save individual `OUTCAR.<kmesh>` files, calculate ΔE (meV/atom), and generate an `kpoints_convergence.dat` file.

### 3. Visualization

Generate and check the convergence plot (`kpoints_convergence.png`):

```bash
gnuplot plot_kpoints.gnu
```

Tip: Look for the energy difference to drop below the **1 meV/atom** red threshold line to determine the optimal `KPOINTS`.
