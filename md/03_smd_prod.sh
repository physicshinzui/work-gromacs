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
cp templates/cv_smd.mdp smd_${id}.mdp
gmx grompp -f smd_${id}.mdp \
           -c npt_eq_${id}.gro \
           -t npt_eq_${id}.cpt \
           -r npt_eq_${id}.gro \
           -p topol.top \
           -po mdout_cv_smd.mdp \
           -n index.ndx  \
           -o smd_${id}.tpr
# - Starting coordinates can be read from trajectory with -t
#   - Only if this information is absent will the coordinates in the -c file be used.    

gmx mdrun -deffnm smd_${id}

# Reverse pulling
cp templates/cv_smd_inv.mdp smd_${id}.mdp
gmx grompp -f smd_${id}.mdp \
           -c smd_${id}.gro \
           -t smd_${id}.cpt \
           -r smd_${id}.gro \
           -p topol.top \
           -po mdout_cv_smd_inv.mdp \
           -n index.ndx \
           -o smd_inv_${id}.tpr

gmx mdrun -deffnm smd_inv_${id}
