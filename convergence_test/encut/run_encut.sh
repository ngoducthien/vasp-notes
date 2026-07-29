#!/bin/bash

# ==================== CONFIGURATION ====================
ENCUT_LIST="300 350 400 450 500 550 600"
VASP_CMD="srun /home/bin/vasp_std_5.4.1"

# Check for essential input files
for f in POSCAR KPOINTS POTCAR INCAR; do
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
echo "=== STARTING ENCUT CONVERGENCE CALCULATIONS ==="

DAT_FILE="encut_convergence.dat"
# Create dat file with Delta E (meV/atom) column
echo "# ENCUT(eV)    Total_Energy(eV)    Delta_E(meV/atom)" > "$DAT_FILE"

prev_energy=""

for encut in $ENCUT_LIST; do
    dir="dir_$encut"
    echo "--------------------------------------------------"
    echo "Processing ENCUT = $encut eV..."
    
    mkdir -p "$dir"
    cp POSCAR KPOINTS POTCAR INCAR "$dir/"
    
    # Update ENCUT inside INCAR
    cd "$dir" || exit
    if grep -q "ENCUT" INCAR; then
        sed -i "s/^[[:space:]]*ENCUT[[:space:]]*=.*/ENCUT = $encut/" INCAR
    else
        echo "ENCUT = $encut" >> INCAR
    fi
    
    # Run VASP
    $VASP_CMD > vasp.out 2>&1
    
    if [ -f "OUTCAR" ]; then
        cp OUTCAR "../OUTCAR.$encut"
        energy=$(grep "TOTEN" OUTCAR | tail -n 1 | awk '{print $5}')
        
        if [ -n "$energy" ]; then
            # Calculate Delta E (meV/atom) relative to the previous ENCUT value
            if [ -n "$prev_energy" ]; then
                # Formula: abs(E_current - E_prev) * 1000 / natoms
                delta_e=$(awk -v e1="$energy" -v e2="$prev_energy" -v n="$natoms" 'BEGIN {val = (e1 - e2)*1000/n; if (val < 0) val = -val; printf "%.4f", val}')
            else
                delta_e="0.0000" # First point has no preceding value to compare with
            fi
            
            echo "-> TOTEN Energy = $energy eV | Delta E = $delta_e meV/atom"
            echo "$encut    $energy    $delta_e" >> "../$DAT_FILE"
            
            prev_energy="$energy"
        else
            echo "-> Warning: TOTEN energy value not found in OUTCAR!"
        fi
    else
        echo "-> Error: OUTCAR file not found."
    fi
    
    cd ..
done

echo "=================================================="
echo "Done! Detailed data file saved as: $DAT_FILE"

# Gnuplot script to plot both total energy and delta E
GNU_FILE="plot_encut.gnu"
cat << EOF > "$GNU_FILE"
set terminal pngcairo enhanced size 900,700 font 'Arial,12'
set output 'encut_convergence.png'

set multiplot layout 2,1 title 'ENCUT Convergence Analysis' font 'Arial,14,Bold'

# Plot 1: Total Energy vs ENCUT
set title 'Total Energy vs ENCUT'
set xlabel 'ENCUT (eV)'
set ylabel 'Total Energy (eV)'
set grid
set format y '%.6f'
plot '$DAT_FILE' using 1:2 with linespoints lw 2 pt 7 ps 1 title 'Total Energy'

# Plot 2: Delta E vs ENCUT (with 1 meV/atom threshold reference line)
set title 'Energy Difference per Atom'
set xlabel 'ENCUT (eV)'
set ylabel 'Delta E (meV/atom)'
set grid
set yrange [0:]
set format y '%.2f'

# Use a function f(x) to plot the horizontal reference line at 1 meV/atom
f(x) = 1.0

plot '$DAT_FILE' using 1:3 with linespoints lw 2 pt 5 ps 1 lc rgb 'blue' title 'Delta E', \
     f(x) with lines lc rgb 'red' dt 2 title 'Threshold (1 meV/atom)'
     
unset multiplot
EOF

echo "Advanced Gnuplot script generated: $GNU_FILE (includes the 1 meV/atom red threshold line)."
