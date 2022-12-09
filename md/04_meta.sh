#!/bin/bash 
set -Ceu
GMX=gmx_plumed
PLM=plumed

id=1
cp ../templates/npt_prod.mdp npt_metad_${id}.mdp
${GMX} grompp -f npt_metad_${id}.mdp \
              -c npt_eq_${id}.gro \
              -r npt_eq_${id}.gro \
              -t npt_eq_${id}.cpt \
              -p topol.top \
              -po mdout_npt_metad.mdp \
              -o npt_metad_${id}.tpr

${GMX} mdrun -deffnm npt_metad_${id} \
             -nsteps 1000 \
             -plumed meta_plumed.dat

#${PLM} sum_hills --hills HILLS --mintozero
