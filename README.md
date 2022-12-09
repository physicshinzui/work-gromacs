# Scripts for Gromacs 
Author: Shinji Iida

## Requirements
- Bash 
- Gromacs 2022.3 (I haven't tested the lower versions yet.)
- PLUMED 2.8.1 (This version is compatible with the Gromacs version.)

## Installation
```
export PATH=path-to-script-directory:$PATH
```

## 1. Simple MD simulations
Em -> Eq (500 ps) -> NPT (production)
```
./run_md [PDB] [boundary type] [no of runs]
```
## 2. Steered MD
Em -> Eq (500 ps) -> NPT SMD (production)
```
./run_smd [PDB] [boundary type] [no of runs]
```

## 3. Metadynamics

## 4. Targeted MD 

