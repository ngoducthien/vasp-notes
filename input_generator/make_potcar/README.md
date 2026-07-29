# make_potcar.sh

A simple Bash script to create a VASP `POTCAR` file by concatenating elemental POTCAR files from a local POTCAR library.

The script also shows alternative POTCAR choices (such as `_pv`, `_sv`, etc.) after creating the final `POTCAR.tmp` file.

## Requirements

- Bash shell
- A local VASP POTCAR library
- Standard VASP POTCAR directory structure

By default, the script expects POTCAR files under:

```text
$HOME/POTCAR/potpaw_PBE/
````

For example:

```
potpaw_PBE/
├── Mg/
│   └── POTCAR
├── Mg_pv/
│   └── POTCAR
├── Mg_sv/
│   └── POTCAR
├── O/
│   └── POTCAR
└── O_h/
    └── POTCAR
```

## Usage

```
./make_potcar.sh Element1 Element2 ...
```

### Examples

Create a POTCAR for MgO:

```
./make_potcar.sh Mg O
```

This generates:

```
POTCAR.tmp
```

