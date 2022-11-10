#!/bin/bash
set -Ceu
cat << EOS
Author: Shinji Iida
This script submits MD runs.
    Usage:
        bash ${0} [run id]  
EOS
id=$1
GMX=gmx

echo "NVT equilibration runs are running..."
cat templates/nvt_eq.mdp | sed -e "s!#{RAND}!${RANDOM}!g" > nvt_eq_${id}.mdp
${GMX} grompp -f nvt_eq_${id}.mdp \
              -c em2.gro \
              -r em2.gro \
              -p topol.top \
              -po mdout_nvt_eq.mdp \
              -o nvt_eq_${id}.tpr
${GMX} mdrun -deffnm nvt_eq_${id}

echo "NPT equilibration runs are running..."
cp templates/npt_eq.mdp npt_eq_${id}.mdp
${GMX} grompp -f npt_eq_${id}.mdp \
              -c nvt_eq_${id}.gro \
              -r nvt_eq_${id}.gro \
              -p topol.top  \
              -po mdout_npt_eq.mdp \
              -o npt_eq_${id}.tpr
${GMX} mdrun -deffnm npt_eq_${id}
