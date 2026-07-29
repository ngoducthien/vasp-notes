#!/bin/bash

# Define the path to Jmol.jar  
JmolPath="/home/codes/jmol-16.3.55/Jmol.jar"  
  
if [ -f "POSCAR" ]; then  
    java -jar $JmolPath POSCAR  
elif [ -f "CONTCAR.relax2" ]; then  
    java -jar $JmolPath CONTCAR.relax2  
else  
    java -jar $JmolPath  
fi
