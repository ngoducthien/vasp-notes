# Compile VASP 5.4.1 with WANNIER90 on NIMS Numerical Materials Simulator

This tutorial explains how to compile **VASP 5.4.1** with **WANNIER90 v1.2** integration on the **NIMS Numerical Materials Simulator**. It involves two steps:

1. **Compiling WANNIER90** first (refer to the tutorial "Compiling WANNIER90 v1.2 on the NIMS Numerical Materials Simulator").
    
2. **Recompiling VASP 5.4.1** to link it with **WANNIER90**.

### **Step 1: Compile WANNIER90**

Before compiling **VASP 5.4.1** with **WANNIER90**, you need to first compile **WANNIER90 v1.2** by following the tutorial:

- [**Compiling WANNIER90 v1.2 on the NIMS Numerical Materials Simulator**](notes/compiling-wannier-v1.2-nims.md).

After following that tutorial, make sure that **WANNIER90** is compiled and that the required libraries (like `libwannier.a`) are available.

### **Step 2: Re-compile VASP 5.4.1 with WANNIER90**

Once **WANNIER90** is compiled, you can proceed with recompiling **VASP 5.4.1** to include **WANNIER90** support by following the tutorial with the modified `makefile.include`
- [**Compiling VASP 5.4.1 on NIMS Numerical Materials Simulator**](notes/compiling-vasp-5.4.1-nims.md) 
#### 1. **Modify `makefile.include`**

In the **VASP** source directory, you need to modify the **`makefile.include`** file to enable the **VASP2WANNIER90** interface.

- Add **`-DVASP2WANNIER90`** to the **`CPP_OPTIONS`**.

Locate the line that defines **`CPP_OPTIONS`** and modify it as follows:

```bash
CPP_OPTIONS= -DMPI -DHOST=\"IFC91_ompi\" -DIFC \
             -DCACHE_SIZE=4000 -DPGF90 -Davoidalloc \
             -DMPI_BLOCK=8000 -DscaLAPACK -Duse_collective \
             -DnoAugXCmeta -Duse_bse_te \
             -Duse_shmem -Dtbdyn \
             -DVASP2WANNIER90
```

This ensures that the necessary preprocessor flags for **VASP2WANNIER90** are included.
#### 2. **Modify `LLIBS` to Link WANNIER90**

You will also need to modify the **`LLIBS`** line to include the **WANNIER90** library (`libwannier.a`), which was generated during the compilation of **WANNIER90**.

Locate the line for **`LLIBS`** and modify it as follows:

```
LLIBS = /home/codes/wannier90-1.2/libwannier.a $(SCALAPACK) $(LAPACK) $(BLAS)
```

Make sure to replace `/home/codes/wannier90-1.2/libwannier.a` with the actual path to **`libwannier.a`** that was generated during the compilation of **WANNIER90**. This ensures that **VASP** links to **WANNIER90** when it is compiled.

#### 3. **Recompile VASP**

Now that the **`makefile.include`** has been modified, you can proceed to recompile **VASP 5.4.1** with the **WANNIER90** interface.

Run the following command in the **VASP** source directory:

```bash
make std
```

This will recompile **VASP 5.4.1** with **WANNIER90** integration, using the modified flags for **WANNIER90** and linking it with the **libwannier.a** library.
