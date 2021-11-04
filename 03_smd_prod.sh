#!/bin/bash
set -Ceu
cat << EOS
Author: Shinji Iida
This script submits MD runs.
    Usage:
        bash ${0} [run id] 
EOS
id=$1

echo "SMD runs are running..."

# Pulling
cp templates/SMD_constVelo.mdp smd_${id}.mdp
gmx grompp -f smd_${id}.mdp  \
           -c npt_eq_${id}.gro    \
           -t npt_eq_${id}.cpt    \
           -r npt_eq_${id}.gro    \
           -p topol.top           \
           -n index.ndx           \
           -o smd_${id}.tpr
# - Starting coordinates can be read from trajectory with -t
#   - Only if this information is absent will the coordinates in the -c file be used.    

gmx mdrun -deffnm smd_${id}

# Reverse pulling
cp templates/SMD_constVelo_inverse.mdp smd_${id}.mdp
gmx grompp -f smd_${id}.mdp  \
           -c smd_${id}.gro    \
           -t smd_${id}.cpt    \
           -r smd_${id}.gro    \
           -p topol.top           \
           -n index.ndx           \
           -o smd_rev${id}.tpr

gmx mdrun -deffnm smd_rev${id}

