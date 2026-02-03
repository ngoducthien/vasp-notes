# Compiling VASP 5.4.1 on NIMS Numerical Materials Simulator

Update: February 03, 2026
## **Load required modules**

```
module purge 
module load inteloneapi/2023.2.0 
module load intel-mpi/2021.16
```

- **inteloneapi**: provides Intel compilers and MKL

- **intel-mpi**: provides MPI libraries for parallel execution


## **Prepare the Makefile**

Use the `makefile.include` you provided, but ensure it contains:
```
# Compiler and precompiler options
CPP_OPTIONS= -DMPI -DHOST=\"IFC91_ompi\" -DIFC \
             -DCACHE_SIZE=4000 -DPGF90 -Davoidalloc \
             -DMPI_BLOCK=8000 -DscaLAPACK -Duse_collective \
             -DnoAugXCmeta -Duse_bse_te \
             -Duse_shmem -Dtbdyn

CPP        = fpp -f_com=no -free -w0  $*$(FUFFIX) $*$(SUFFIX) $(CPP_OPTIONS)
FC         = mpiifort
FCL        = mpiifort -qmkl
FREE       = -free -names lowercase
FFLAGS     = -assume byterecl
OFLAG      = -O2
OFLAG_IN   = $(OFLAG)
DEBUG      = -O0

MKL_PATH   = $(MKLROOT)/lib/intel64
BLAS       =
LAPACK     =
BLACS      = -lmkl_blacs_intelmpi_lp64
SCALAPACK  = $(MKL_PATH)/libmkl_scalapack_lp64.a $(BLACS)

OBJECTS    = fftmpiw.o fftmpi_map.o fftw3d.o fft3dlib.o
INCS       = -I$(MKLROOT)/include/fftw
LIBS       = $(SCALAPACK) $(LAPACK) $(BLAS)

# VASP.5.lib files
CPP_LIB    = $(CPP)
FC_LIB     = $(FC)
CC_LIB     = icc
CFLAGS_LIB = -O
FFLAGS_LIB = -O1
FREE_LIB   = $(FREE)
OBJECTS_LIB= linpack_double.o getshmem.o

SRCDIR     = ../../src
BINDIR     = ../../bin

```

## **Compile VASP**
```
make std
```

- Should produce `vasp_std`, `vasp_gam`, `vasp_ncl` in `../../bin/`


## **Test VASP**

Create a static calculation:

**POSCAR**:

```
SrTiO3                            
   1.00000000000000     
     3.9438747811043422   -0.0000000000000000    0.0000000000000000
     0.0000000000000000    3.9438747811043422   -0.0000000000000000
    -0.0000000000000000    0.0000000000000000    3.9438747811043422
   Sr   Ti   O 
     1     1     3
Direct
  0.0000000000000000  0.0000000000000000  0.0000000000000000
  0.5000000000000000  0.5000000000000000  0.5000000000000000
  0.0000000000000000  0.5000000000000000  0.5000000000000000
  0.5000000000000000  0.0000000000000000  0.5000000000000000
  0.5000000000000000  0.5000000000000000  0.0000000000000000
 
  0.00000000E+00  0.00000000E+00  0.00000000E+00
  0.00000000E+00  0.00000000E+00  0.00000000E+00
  0.00000000E+00  0.00000000E+00  0.00000000E+00
  0.00000000E+00  0.00000000E+00  0.00000000E+00
  0.00000000E+00  0.00000000E+00  0.00000000E+00
```

**KPOINTS**
```
Automatic
0
Monkhrost-Pack
8 8 8
0 0 0
```

**INCAR**
```
PREC       = Accurate
ISTART     = 0
ALGO       = Normal
EDIFF      = 1.E-6
ENCUT      = 520
LREAL      = .FALSE.
NELM       = 256
LWAVE      = .FALSE.
LCHARG     = .FALSE.
ISMEAR     = 0
SIGMA      = 0.05
ADDGRID    = .TRUE.
```

**POTCAR**
```
   TITEL  = PAW_PBE Sr_sv 07Sep2000
   TITEL  = PAW_PBE Ti_pv 07Sep2000
   TITEL  = PAW_PBE O 08Apr2002
```

**Batch Job File**

Filename: job_vasp

```
#! /bin/bash
#SBATCH -J my-first-job
#SBATCH -p qM
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o mpi_job.out
#SBATCH -e mpi_job.err
#SBATCH -t 01:00:00

module load inteloneapi/2023.2.0
module load intel-mpi/2021.16

srun ~/path/to/bin/vasp_std
```

**Submit the script file**

```
sbatch job_vasp
```

**Output**

If the compilation and calculation run well, the output of `mpi_job.out` will be as follows:

```
 running on    1 total cores
 distrk:  each k-point on    1 cores,    1 groups
 distr:  one band on    1 cores,    1 groups
 using from now: INCAR     
 vasp.5.4.1 24Jun15 (build Feb 03 2026 15:18:26) complex                        
  
 POSCAR found type information on POSCAR  Sr Ti O 
 POSCAR found :  3 types and       5 ions
 scaLAPACK will be used
 LDA part: xc-table for Pade appr. of Perdew
 POSCAR, INCAR and KPOINTS ok, starting setup
 FFT: planning ...
 WAVECAR not read
 entering main loop
       N       E                     dE             d eps       ncg     rms          rms(c)
DAV:   1     0.429831356468E+03    0.42983E+03   -0.20652E+04   920   0.175E+03
DAV:   2    -0.438085419596E+01   -0.43421E+03   -0.42568E+03  1148   0.471E+02
DAV:   3    -0.487034444711E+02   -0.44323E+02   -0.41940E+02  1025   0.141E+02
DAV:   4    -0.504760361014E+02   -0.17726E+01   -0.17709E+01  1493   0.292E+01
DAV:   5    -0.505221043529E+02   -0.46068E-01   -0.46061E-01  1266   0.358E+00    0.309E+01
DAV:   6    -0.401117850723E+02    0.10410E+02   -0.65280E+01  1378   0.676E+01    0.151E+01
DAV:   7    -0.401489468652E+02   -0.37162E-01   -0.88536E+00  1143   0.230E+01    0.116E+01
DAV:   8    -0.400492008112E+02    0.99746E-01   -0.17501E+00  1241   0.150E+01    0.256E+00
DAV:   9    -0.400004185226E+02    0.48782E-01   -0.25566E-01  1219   0.514E+00    0.853E-01
DAV:  10    -0.399975459884E+02    0.28725E-02   -0.67765E-02  1159   0.168E+00    0.771E-01
DAV:  11    -0.399934968578E+02    0.40491E-02   -0.32833E-02  1307   0.207E+00    0.243E-01
DAV:  12    -0.399933859812E+02    0.11088E-03   -0.18620E-03   964   0.379E-01    0.176E-01
DAV:  13    -0.399931682996E+02    0.21768E-03   -0.84471E-04  1400   0.371E-01    0.507E-02
DAV:  14    -0.399931795623E+02   -0.11263E-04   -0.88850E-05  1132   0.737E-02    0.387E-02
DAV:  15    -0.399931681279E+02    0.11434E-04   -0.28511E-05  1212   0.639E-02    0.110E-02
DAV:  16    -0.399931682653E+02   -0.13734E-06   -0.11844E-05  1227   0.263E-02    0.375E-03
DAV:  17    -0.399931682071E+02    0.58129E-07   -0.50200E-07   518   0.605E-03
   1 F= -.39993168E+02 E0= -.39993168E+02  d E =-.968948E-16
```