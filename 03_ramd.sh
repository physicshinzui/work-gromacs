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
cat templates/ramd.mdp | sed -e "s!#{SEED}!${RANDOM}!g" > ramd_${id}.mdp
gmx grompp -f ramd_${id}.mdp  \
            -c npt_eq_${id}.gro    \
            -t npt_eq_${id}.cpt    \
            -p topol.top           \
            -o ramd_${id}.tpr
# - Starting coordinates can be read from trajectory with -t
#   - Only if this information is absent will the coordinates in the -c file be used.    

gmx mdrun -deffnm ramd_${id}
