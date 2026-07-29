# Custodian Double Relaxation

This example demonstrates how to perform a double relaxation workflow in VASP using **Custodian**. The workflow runs two consecutive geometry optimizations while taking advantage of Custodian's automatic error handling and job recovery.

## Requirements

* Custodian

## Configuration

Before running the workflow, edit `input.py` to match your VASP executable and job launcher. For example:

```python
vasp = "/home/duc/bin/vasp_std_5.4.1"
vasp_cmd = ["srun", vasp]
```

Replace the executable path and launcher (`srun`) with those appropriate for your computing environment.

