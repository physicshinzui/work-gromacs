#!/bin/bash 
set -eu
GMX=gmx-colvar

id=1
XYZ=ref.xyz

cat templates/nvt_vac.mdp | sed -e "s!#{RAND}!${RANDOM}!g" > tmd_rmsd_${id}.mdp
${GMX} grompp -f tmd_rmsd_${id}.mdp \
              -c nvt_vac_${id}.gro \
              -r nvt_vac_${id}.gro \
              -t nvt_vac_${id}.cpt \
              -p topol.top \
              -po mdout_tmd_rmsd.mdp \
              -o tmd_rmsd_${id}.tpr

cat templates_colvar/colvar_rmsd_tmd.dat | sed -e "s/#{XYZ}/${XYZ}/g" > tmd_rmsd_colvar.dat
${GMX} mdrun -deffnm tmd_rmsd_${id} \
             --colvars tmd_rmsd_colvar.dat \
             -nsteps 500000
