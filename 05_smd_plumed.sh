#!/bin/bash 
set -Ceu
GMX=gmx_plumed
PLM=plumed

id=1

cat templates/nvt_vac.mdp | sed -e "s!#{RAND}!${RANDOM}!g" > smd_${id}.mdp
${GMX} grompp -f smd_${id}.mdp \
              -c nvt_vac_${id}.gro \
              -r nvt_vac_${id}.gro \
              -t nvt_vac_${id}.cpt \
              -p topol.top \
              -po mdout_smd.mdp \
              -o smd_${id}.tpr

#cp templates/npt_prod.mdp smd_${id}.mdp
#${gmx} grompp -f smd_${id}.mdp \
#              -c npt_eq_${id}.gro \
#              -r npt_eq_${id}.gro \
#              -t npt_eq_${id}.cpt \
#              -p topol.top \
#              -po mdout_smd.mdp \
#              -o smd_${id}.tpr

REF=ref_em.pdb
cat templates_plumed/plumed_smd.dat | sed -e "s/#{PDB}/${REF}/g" > plumed_smd.dat
${GMX} mdrun -deffnm smd_${id} \
             -nsteps 1000 \
             -plumed plumed_smd.dat
