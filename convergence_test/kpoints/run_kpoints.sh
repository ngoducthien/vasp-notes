#!/bin/bash

# ==================== CONFIGURATION ====================
# List of K-point meshes you want to test (each entry represents Nx Ny Nz)
KPOINTS_LIST="4x4x4 6x6x6 8x8x8 10x10x10 12x12x12 14x14x14 16x16x16"
VASP_CMD="srun /home/duc/bin/vasp_std_5.4.1"

# Check for essential input files (Note: KPOINTS file is not needed here as it will be generated automatically)
for f in POSCAR POTCAR INCAR; do
    if [ ! -f "$f" ]; then
        echo "Error: Required file $f not found in the current directory!"
        exit 1
    fi
done

# Read the total number of atoms from POSCAR (summing up the numbers on line 7)
# Assuming VASP 5+ format (element symbols on line 6, counts on line 7)
natoms=$(sed -n '7p' POSCAR | awk '{sum=0; for(i=1;i<=NF;i++) sum+=$i; print sum}')
if [ -z "$natoms" ] || [ "$natoms" -le 0 ]; then
    # Fallback for older POSCAR format (counts on line 6)
    natoms=$(sed -n '6p' POSCAR | awk '{sum=0; for(i=1;i<=NF;i++) sum+=$i; print sum}')
fi

echo "=== TOTAL NUMBER OF ATOMS IN UNIT CELL: $natoms ==="
echo "=== STARTING KPOINTS CONVERGENCE CALCULATIONS ==="

DAT_FILE="kpoints_convergence.dat"
# Create dat file with Delta E (meV/atom) column
echo "# K_Mesh    Total_Energy(eV)    Delta_E(meV/atom)" > "$DAT_FILE"

prev_energy=""
index=1

for kmesh in $KPOINTS_LIST; do
    # Replace 'x' with space to generate VASP KPOINTS format (e.g., "4x4x4" -> "4 4 4")
    k_space=$(echo "$kmesh" | tr 'x' ' ')
    
    dir="dir_$kmesh"
    echo "--------------------------------------------------"
    echo "Processing K-mesh = $kmesh..."
    
    mkdir -p "$dir"
    cp POSCAR POTCAR INCAR "$dir/"
    
    # Automatically generate the Gamma-centered KPOINTS file inside the subdirectory
    cat << EOF > "$dir/KPOINTS"
Automatic mesh
0
Gamma
 $k_space
 0 0 0
EOF
    
    # Run VASP
    cd "$dir" || exit
    $VASP_CMD > vasp.out 2>&1
    
    if [ -f "OUTCAR" ]; then
        cp OUTCAR "../OUTCAR.$kmesh"
        energy=$(grep "TOTEN" OUTCAR | tail -n 1 | awk '{print $5}')
        
        if [ -n "$energy" ]; then
            # Calculate Delta E (meV/atom) relative to the previous K-mesh value
            if [ -n "$prev_energy" ]; then
                # Formula: abs(E_current - E_prev) * 1000 / natoms
                delta_e=$(awk -v e1="$energy" -v e2="$prev_energy" -v n="$natoms" 'BEGIN {val = (e1 - e2)*1000/n; if (val < 0) val = -val; printf "%.4f", val}')
            else
                delta_e="0.0000" # First point has no preceding value to compare with
            fi
            
            echo "-> TOTEN Energy = $energy eV | Delta E = $delta_e meV/atom"
            # Save using an index column (1, 2, 3...) for easy plotting on x-axis
            echo "$index    $energy    $delta_e    $kmesh" >> "../$DAT_FILE"
            
            prev_energy="$energy"
        else
            echo "-> Warning: TOTEN energy value not found in OUTCAR!"
        fi
    else
        echo "-> Error: OUTCAR file not found."
    fi
    
    cd ..
    index=$((index + 1))
done

echo "=================================================="
echo "Done! Detailed data file saved as: $DAT_FILE"

# Gnuplot script to plot both total energy and delta E using string labels on x-axis
GNU_FILE="plot_kpoints.gnu"
cat << EOF > "$GNU_FILE"
set terminal pngcairo enhanced size 900,700 font 'Arial,12'
set output 'kpoints_convergence.png'

set multiplot layout 2,1 title 'KPOINTS Convergence Analysis' font 'Arial,14,Bold'

# Plot 1: Total Energy vs K-mesh
set title 'Total Energy vs K-points'
set ylabel 'Total Energy (eV)'
set grid
set format y '%.6f'
set xtics nomirror
plot '$DAT_FILE' using 1:2:4:xtic(4) with linespoints lw 2 pt 7 ps 1 title 'Total Energy'

# Plot 2: Delta E vs K-mesh (with 1 meV/atom threshold reference line)
set title 'Energy Difference per Atom'
set ylabel 'Delta E (meV/atom)'
set grid
set yrange [0:]
set format y '%.2f'
set xtics nomirror

# Use a function f(x) to plot the horizontal reference line at 1 meV/atom
f(x) = 1.0

plot '$DAT_FILE' using 1:3:4:xtic(4) with linespoints lw 2 pt 5 ps 1 lc rgb 'blue' title 'Delta E', \
     f(x) with lines lc rgb 'red' dt 2 title 'Threshold (1 meV/atom)'
     
unset multiplot
EOF

echo "Advanced Gnuplot script generated: $GNU_FILE (includes the 1 meV/atom red threshold line)."
