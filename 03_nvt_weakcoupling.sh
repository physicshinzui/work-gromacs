#!/bin/bash
set -Ceu
cat << EOS
Author: Shinji Iida
This script submits MD runs.
    Usage:
        bash ${0} [run id] 
EOS
id=$1

cp templates/nvt_prod_weakcoupling.mdp nvt_prod_weakcoupling_${id}.mdp
gmx grompp -f nvt_prod_weakcoupling_${id}.mdp  \
            -c npt_eq_${id}.gro    \
            -t npt_eq_${id}.cpt    \
            -p topol.top           \
            -o nvt_prod_weakcoupling_${id}.tpr
# - Starting coordinates can be read from trajectory with -t
#   - Only if this information is absent will the coordinates in the -c file be used.    

gmx mdrun -deffnm nvt_prod_weakcoupling_${id} 
