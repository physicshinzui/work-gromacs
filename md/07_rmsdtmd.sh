#!/bin/bash 
set -eu
GMX=gmx_plumed
PLM=plumed

id=1

cat templates/nvt_vac.mdp | sed -e "s!#{RAND}!${RANDOM}!g" > rmsdtmd_${id}.mdp
${GMX} grompp -f rmsdtmd_${id}.mdp \
              -c nvt_vac_${id}.gro \
              -r nvt_vac_${id}.gro \
              -t nvt_vac_${id}.cpt \
              -p topol.top \
              -po mdout_rmsdtmd.mdp \
              -o rmsdtmd_${id}.tpr

#cp templates/npt_prod.mdp smd_${id}.mdp
#${gmx} grompp -f smd_${id}.mdp \
#              -c npt_eq_${id}.gro \
#              -r npt_eq_${id}.gro \
#              -t npt_eq_${id}.cpt \
#              -p topol.top \
#              -po mdout_smd.mdp \
#              -o smd_${id}.tpr

REF=ref_em.pdb
RMSDREF=rref.pdb
cat templates_plumed/plumed_rmsdtmd.dat | \
	sed -e "s/#{PDB}/${REF}/g" | \
	sed -e "s/#{REF}/${RMSDREF}/g" \
	> plumed_rmsdtmd.dat
${GMX} mdrun -deffnm rmsdtmd_${id} \
             -nsteps 100000 \
             -plumed plumed_rmsdtmd.dat
