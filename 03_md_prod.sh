#!/bin/bash
set -Ceu
cat << EOS
Author: Shinji Iida
This script submits MD runs.
    Usage:
        bash ${0} [run id] 
EOS
id=$1
GMX-gmx

type=npt

if [ $type -eq "npt" ]; then  
    echo "NPT runs are running..."
    cp templates/npt_prod.mdp npt_prod_${id}.mdp
    $GMX grompp -f npt_prod_${id}.mdp  \
                -c npt_eq_${id}.gro    \
                -t npt_eq_${id}.cpt    \
                -p topol.top           \
                -o npt_prod_${id}.tpr
    # - Starting coordinates can be read from trajectory with -t
    #   - Only if this information is absent will the coordinates in the -c file be used.    
    
    $GMX mdrun -deffnm npt_prod_${id}

elif [ $type -eq "nvt" ] ; then 
    echo "NVT runs are running..."
    cp templates/nvt_prod.mdp nvt_prod_${id}.mdp
    $GMX grompp -f nvt_prod_${id}.mdp  \
                -c nvt_eq_${id}.gro    \
                -t nvt_eq_${id}.cpt    \
                -p topol.top           \
                -o nvt_prod_${id}.tpr
    # - Starting coordinates can be read from trajectory with -t
    #   - Only if this information is absent will the coordinates in the -c file be used.    
    
    $GMX mdrun -deffnm nvt_prod_${id}
fi 
