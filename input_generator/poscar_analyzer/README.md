# vasp-poscar-analyzer

## Overview

`vasp_poscar_analyzer` is a Fortran90 program that extracts and displays important structural information from a VASP POSCAR file. It calculates and presents the lattice parameters, inter-axial angles, and the cell volume, providing an essential tool for researchers working with crystal structures in computational materials science.

## Purpose

The program serves to facilitate the analysis of lattice constants and geometrical properties of materials simulated using VASP (Vienna Ab-initio Simulation Package). By reading the POSCAR file, it scales the lattice vectors according to the specified factor and computes:

- Lattice constants (a, b, c)
- Inter-axial angles (α, β, γ)
- Cell volume

## Compilation

To compile the program, use the following command:

```bash
gfortran -o vasp_poscar_analyzer vasp_poscar_analyzer.f90
```

Ensure you replace `vasp_poscar_analyzer.f90` with the actual filename of the source code if it differs.

After compilation, you can add the `vasp_poscar_analyzer` to your PATH for easier access. You can do this by moving the executable to a directory that is already in your PATH, or by creating a symbolic link:

```bash
# Move to /usr/local/bin (requires sudo)
sudo mv vasp_poscar_analyzer /usr/local/bin/

# Or create a symbolic link (requires sudo)
sudo ln -s /path/to/your/vasp_poscar_analyzer /usr/local/bin/vasp_poscar_analyzer
```

Replace `/path/to/your/vasp_poscar_analyzer` with the actual path to your compiled executable. After this, you can run `vasp_poscar_analyzer` from any directory.

## Usage

To use the `vasp_poscar_analyzer`, follow these steps:

1. Navigate to the directory containing your VASP calculation files:
   ```bash
   cd /path/to/your/vasp/calculation/folder

2. Run the program with the POSCAR/CONTCAR file as an argument:

    ```bash

    ./vasp_poscar_analyzer POSCAR
    ```

    ```bash

    ./vasp_poscar_analyzer CONTCAR
    ```
## Output

The program will display the following information in the terminal:

- Lattice constants (a, b, c) in Angstroms
- Inter-axial angles (α, β, γ) in degrees
- Cell volume in Angstrom³

Additionally, it outputs a comma-separated line of values for easy export and further analysis.

## Requirements

Fortran90 compiler (e.g., gfortran)

Basic knowledge of command line usage

