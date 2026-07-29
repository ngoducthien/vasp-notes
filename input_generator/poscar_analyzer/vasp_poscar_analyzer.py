import sys
import numpy as np

# Get the filename from the command line, defaulting to 'POSCAR'
file = sys.argv[1] if len(sys.argv) > 1 else 'POSCAR'

# Constants
rad_to_deg = 180 / np.pi

# Read the file once and close it, minimizing file I/O
with open(file, 'r') as target:
    data = target.read().splitlines()

# Scale factor and coordinate parsing
ax = float(data[1].strip())
R_v = np.array([list(map(float, data[i].split())) for i in range(2, 5)], dtype='float64') * ax

# Calculate lattice constants
a, b, c = np.linalg.norm(R_v, axis=1)

# Volume calculation using determinant for improved readability
volume = np.linalg.det(R_v)

# Dot products for angle calculations
axb = np.dot(R_v[0], R_v[1])
bxc = np.dot(R_v[1], R_v[2])
cxa = np.dot(R_v[2], R_v[0])

# Angle calculations
alpha = np.arccos(bxc / (b * c)) * rad_to_deg
beta = np.arccos(cxa / (c * a)) * rad_to_deg
gamma = np.arccos(axb / (a * b)) * rad_to_deg

# Output results with unified formatting
print(f"a = {a:18.11f} Å; {a * 0.1:18.11f} nm")
print(f"b = {b:18.11f} Å; {b * 0.1:18.11f} nm")
print(f"c = {c:18.11f} Å; {c * 0.1:18.11f} nm")
print(f"a = {a:.3f}; b = {b:.3f}; c = {c:.3f}\n")
print(f"a/c = {a/c:18.11f}")
print(f"c/a = {c/a:18.11f}\n")
print(f"{a:.4f}\t{b:.4f}\t{c:.4f}\t{a/c:.4f}\t{volume:.4f}\n")
print(f"alpha = {alpha:18.11f}")
print(f"beta  = {beta:18.11f}")
print(f"gamma = {gamma:18.11f}\n")
print(f"volume = {volume:18.11f} Å^3")
