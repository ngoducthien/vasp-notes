# vasp-notes
A collection of notes, tips, tricks, and guides on compiling, running, and troubleshooting VASP (Vienna Ab initio Simulation Package).

## Compilation of VASP

This section covers everything related to **compiling** VASP, including setting up the environment and resolving common compilation issues.

- [**Compiling VASP 5.4.1 on NIMS Numerical Materials Simulator**](notes/compiling-vasp-5.4.1-nims.md) (**Update: February 03, 2026**).

- [**Compiling VASP 5.4.1 on Hokkaido University's Supercomputer**](notes/compiling-vasp-5.4.1-hokkaido-univ.md) (**Update: November 07, 2020**).

- [**Compiling VASP 5.4.1 on Linux (Ubuntu 18.04)**](notes/compiling-vasp-5.4.1-ubuntu-18.04.md) (**Update: April 24, 2020**).


## Compilation of Supported Packages

- [**Compiling WANNIER90 v1.2 on the NIMS Numerical Materials Simulator**](notes/compiling-wannier-v1.2-nims.md) (**Update: February 05, 2026**).

- [**Compile VASP 5.4.1 with WANNIER90 on NIMS Numerical Materials Simulator**](notes/compiling-vasp-5.4.1-and-wannier-v1.2-nims.md) (**Update: February 06, 2026**).

## Input Generators

- [**POTCAR**](input_generator/make_potcar/README.md)

- [**INCAR Explainer**](input_generator/incar_explainer/README.md): A Python script that explains the function of VASP tags in an INCAR file.

- [**POSCAR Analyzer**](input_generator/poscar_analyzer/README.md): A Fortran 90 program that extracts and displays lattice parameters from a POSCAR file.

## Convergence Tests

- [**ENCUT**](convergence_test/encut/README.md)

- [**KPOINTS**](convergence_test/kpoints/README.md)

## Workflows

- [**Custodian Double Relaxation**](custodian_double_relax/)

## Visualization

- [**Viewing a VASP POSCAR with Jmol**](visualization/view-poscar/README.md)
