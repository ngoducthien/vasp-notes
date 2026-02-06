# Compile WANNIER90 v1.2 on NIMS Numerical Materials Simulator

Update: February 05, 2026

This tutorial provides a step-by-step guide to compile **WANNIER90 v1.2** on the **NIMS supercomputer** using the **Intel compilers**, **Intel oneAPI**, and **Intel MKL libraries**.
## **Overview**
- **WANNIER90 Version**: v1.2
- **VASP2WANNIER90** Interface: Works with **WANNIER90 v1.2**, not **v2.0** (as of now).
- **Compiler**: Intel Compiler (`ifort`) with Intel oneAPI and MKL.

## **Steps**
### **1. Download WANNIER90 v1.2 Source Code**

Download the source code of **WANNIER90 v1.2** from the official website, after downloading, untar the source code:

```bash
tar -xvzf wannier90-1.2.tar.gz
cd wannier90-1.2
```
### **2. Load Necessary Modules**

On the **NIMS supercomputer**, use the **Intel oneAPI** and **Intel MPI** modules before compiling:

```bash
module purge
module load inteloneapi/2023.2.0
module load intel-mpi/2021.16
```

These modules set up the **Intel compilers**, **Intel MKL**, and **Intel MPI** environment.

### **3. Set Environment Variables**

Set the **MKLROOT** environment variable to the correct Intel MKL directory and update the **LD_LIBRARY_PATH** to include the MKL library directory. These variables ensure the Intel Math Kernel Library (MKL) is found by the compiler and linker during compilation and execution.

```bash
export MKLROOT=/app/intel/oneapi/mkl/2024.1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MKLROOT/lib/intel64
```

Make sure that the paths are correct according to your system’s configuration. Adjust the `MKLROOT` path if necessary.
### **4. Prepare the Makefile**

Modify the `make.sys` file to use the correct Intel compiler and MKL libraries.

Here is the relevant section to modify:

```bash
#=========================================================
# For Linux with Intel oneAPI (2023.x)
#=========================================================
F90     = ifort
FCOPTS  = -O2
LDOPTS  = -O2

#=========================================================
# Intel MKL (provided by inteloneapi module)
#=========================================================
LIBDIR = $(MKLROOT)/lib/intel64
LIBS   = -L$(LIBDIR) \
         -lmkl_intel_lp64 \
         -lmkl_core \
         -lmkl_sequential \
         -lpthread

#=========================================================
# Optional: ATLAS / Netlib BLAS & LAPACK (unused)
#=========================================================
# LIBDIR = /usr/local/lib
# LIBS   = -L$(LIBDIR) -llapack -lblas
```

### **5. Compile WANNIER90**

Now that you’ve set the environment variables and updated the `make.sys` file, proceed to compile the code.

**Run the following `make` command to compile the main program and the libraries**:

```bash
make wannier lib test
```

This will:

- **`wannier`**: Compile the main WANNIER90 executable (`wannier90.x`).
- **`lib`**: Compile the required libraries.
- **`test`**: Run any precompiled tests to check if the build was successful.

### **6. Verify the Compilation**

Once the `make` command completes, check if the executable `wannier90.x` is created:

```bash
ls -l wannier90.x
```

You should see the compiled binary `wannier90.x` in the directory.

To verify that everything is set up correctly, run a test example:

```bash
./wannier90.x < test_example > output.log
```

Check the `output.log` for any errors. If everything is set up correctly, the output should indicate that the code has run successfully.

### **7. Clean Up (Optional)**

After compilation, you can clean the intermediate object files and libraries:

```bash
make veyclean
```

This will remove the object files (`*.o`) and other temporary files created during the build process.