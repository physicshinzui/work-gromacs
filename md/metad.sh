#!/bin/bash 
set -Ceu
GMX=gmx_plumed
PLM=plumed
id=$1
nsteps=$2

cat<<EOF
##########################################
Usage: 
    $0 [id] [nsteps]

Metadynamics at NPT ensemble is performed.
##########################################
EOF

prepare_mdps () {
    cp ../templates/npt_prod.mdp npt_metad_${id}.mdp
    cp ../templates_plumed/metad_1d.dat metad.dat
}

prepare_mdps

${GMX} grompp -f npt_metad_${id}.mdp \
              -c npt_eq_${id}.gro \
              -r npt_eq_${id}.gro \
              -t npt_eq_${id}.cpt \
              -p topol.top \
              -po mdout_npt_metad.mdp \
              -o npt_metad_${id}.tpr

${GMX} mdrun -deffnm npt_metad_${id} \
             -nsteps $nsteps \
             -plumed metad.dat

#${PLM} sum_hills --hills HILLS --mintozero
