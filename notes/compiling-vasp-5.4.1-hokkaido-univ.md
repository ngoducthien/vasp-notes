# Compiling VASP 5.4.1 on Hokkaido University's Supercomputer

Update: November 07, 2020

This note documents how to compile VASP 5.4.1 on the Hokkaido University's Supercomputer, using Intel 2019 compilers and MPI-FFTW.

## **Avoid “catastrophic error”**

Before compiling, make sure the locale is set correctly. This avoids Fortran catastrophic error issues during compilation.

```
export LANG=en_US.utf8
export LC_ALL=en_US.utf8
```

You may want to add these lines to your .bashrc if you compile frequently.

## **Load required modules**

Load the default Intel compiler, Intel MPI, and MPI-enabled FFTW:

```
module load impi/2019.5.281
module load intel/2019.5.281
module load mpi-fftw/3.3.8
```

Check that the modules are loaded correctly:

```
module list
```

## **Apply VASP patches**

From the VASP 5.4.1 source directory, apply the required patches in the following order:

```
patch -p1 < patch.5.4.1.08072015
patch -p0 < patch.5.4.1.27082015
patch -p1 < patch.5.4.1.06112015
```

Make sure there are no .rej files after applying the patches.

## **Modify makefile.include**

Edit makefile.include to explicitly link against MPI-FFTW provided by Hokkaido University's Supercomputer.

Update the FFTW-related lines:

```
OBJECTS = fftmpiw.o fftmpi_map.o fftw3d.o fft3dlib.o \
/home/opt/local/apps/intel/2019.5.281/impi/2019.5.281/mpi-fftw/3.3.8/lib/libfftw3_mpi.a

INCS = -I/home/opt/local/apps/intel/2019.5.281/impi/2019.5.281/mpi-fftw/3.3.8/include
```

This ensures VASP uses the MPI-enabled FFTW instead of the internal FFT routines.

## **Compile VASP**

Compile the standard VASP binary:

```
make std
```

If the compilation succeeds, the binary will be generated in:

```
bin/vasp_std
```
