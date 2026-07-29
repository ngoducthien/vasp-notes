#  Viewing VASP POSCAR with Jmol on a Supercomputer

![POSCAR](jmol_screenshot.png)

### 1. Download and Extract Jmol

Download Jmol and unpack it in your home or work directory. This will give you a folder containing `Jmol.jar`.  

Note its full path (you’ll need it in the script). Ensure Java is available by running:

```bash
java --version
```

### 2. Create a `viewposcar` Command

Create a personal executable script in `~/bin/viewposcar`:

Paste the following:

```shell
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
```
  
Make it executable:
```shell
chmod +x ~/bin/viewposcar
```

Make sure `~/bin` is in your PATH.

### 3. Use the Command

Navigate to your VASP calculation folder and simply run:

```
viewposcar
```

- If `POSCAR` exists, it opens automatically
- If not, it tries `CONTCAR.relax2` (For custodian double relaxation)
- Otherwise, launches Jmol empty
