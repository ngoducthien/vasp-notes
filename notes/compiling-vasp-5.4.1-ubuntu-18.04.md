# Compiling VASP 5.4.1 on Linux (Ubuntu 18.04)

This note describes how to compile VASP 5.4.1 on Ubuntu 18.04, using GNU compilers, OpenMPI, BLAS/LAPACK, ScaLAPACK, and FFTW provided by the system package manager.

## **Install necessary packages**

Update your package list and install all required build tools and numerical libraries:

```
sudo apt-get update

sudo apt-get install make build-essential g++ gfortran
sudo apt-get install \
    libblas-dev \
    liblapack-dev \
    libopenmpi-dev \
    libscalapack-mpi-dev \
    libfftw3-dev
```

You can verify the MPI compiler is available with:

```
which mpif90
```

## **Prepare makefile.include**

Copy a GNU-based template to makefile.include and modify it as follows:

```
# Precompiler options
CPP_OPTIONS = -DHOST=\"LinuxGNU\" \
              -DMPI -DMPI_BLOCK=8000 -Duse_collective \
              -DscaLAPACK -DCACHE_SIZE=4000 \
              -Davoidalloc -Duse_bse_te \
              -Dtbdyn

CPP        = gcc -E -P -C -w $*$(FUFFIX) > $*$(SUFFIX) $(CPP_OPTIONS)

FC         = mpif90
FCL        = mpif90

FREE       = -ffree-form -ffree-line-length-none
FFLAGS     = -w
OFLAG      = -O2 -mtune=native -m64
OFLAG_IN   = $(OFLAG)
DEBUG      = -O0

LIBDIR     = /usr/lib/x86_64-linux-gnu

BLAS       = -L$(LIBDIR) -lblas
LAPACK     = -L$(LIBDIR) -llapack
BLACS      =
SCALAPACK  = -L/usr/lib -lscalapack-openmpi $(BLACS)

LLIBS      = $(SCALAPACK) $(LAPACK) $(BLAS)
LLIBS     += -lfftw3

INCS       = -I/usr/include

OBJECTS    = fftmpiw.o fftmpi_map.o fftw3d.o fft3dlib.o
OBJECTS_O1 += fftw3d.o fftmpi.o fftmpiw.o
OBJECTS_O2 += fft3dlib.o

# For what used to be vasp.5.lib
CPP_LIB    = $(CPP)
FC_LIB     = $(FC)
CC_LIB     = gcc
CFLAGS_LIB = -O
FFLAGS_LIB = -O1
FREE_LIB   = $(FREE)
OBJECTS_LIB= linpack_double.o getshmem.o

# Parser library
CXX_PARS   = g++
LIBS      += parser
LLIBS     += -Lparser -lparser -lstdc++

# Normally no need to change this
SRCDIR     = ../../src
BINDIR     = ../../bin
```

## **Build standard VASP binary**

Compile the standard (vasp_std) version only:

```
make std
```

If the compilation succeeds, the executable will be located at:

```
bin/vasp_std
```

## **Notes**

   - This setup is suitable for small to medium-sized calculations on a single workstation or small cluster.

   - Performance will be lower than Intel OneAPI builds, but stability and simplicity are excellent.

   - For Ubuntu ≥ 20.04, library names and paths may differ slightly.
