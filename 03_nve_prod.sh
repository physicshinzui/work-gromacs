#!/bin/bash
set -Ceu
cat << EOS
Author: Shinji Iida
This script submits MD runs.
    Usage:
        bash ${0} [run id] 
EOS
id=$1

echo "NPT runs are running..."
cp templates/nve_prod.mdp nve_prod_${id}.mdp
gmx grompp -f nve_prod_${id}.mdp  \
           -c npt_eq_${id}.gro    \
           -t npt_eq_${id}.cpt    \
           -p topol.top           \
           -o nve_prod_${id}.tpr
# - Starting coordinates can be read from trajectory with -t
#   - Only if this information is absent will the coordinates in the -c file be used.    

gmx mdrun -deffnm nve_prod_${id}