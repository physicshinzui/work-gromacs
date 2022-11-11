#!/bin/bash
set -eu
cat << EOS
Author: Shinji Iida
This script automates a system preparation for Gromacs.
    Usage:
        bash ${0} [PDB file] [MD STEPS] [nvt/nve] [MD run id (int/str)]
EOS

GMX=gmx
inputPDBName=$1
MDSTEPS=$2
ENS=$3
id=$4
proteinName=`basename ${inputPDBName%.*}`

${GMX} pdb2gmx -f ${inputPDBName} -o ${proteinName}_processed.gro -water tip3p

${GMX} editconf -f ${proteinName}_processed.gro \
              -o ${proteinName}_newbox.gro \
              -box 1000.0 1000.0 1000.0 \
              -bt cubic

echo "Energy minimisation ..."
${GMX} grompp -f templates/em_vac.mdp \
            -c ${proteinName}_newbox.gro \
            -r ${proteinName}_newbox.gro \
            -p topol.top \
            -po mdout_em.mdp \
            -o em.tpr
${GMX} mdrun -deffnm em

if [ $ENS = "nvt" ]; then
    echo "NVT runs..."
    cat templates/nvt_vac.mdp | sed -e "s!#{RAND}!${RANDOM}!g" > nvt_vac_${id}.mdp
    ${GMX} grompp -f nvt_vac_${id}.mdp \
                  -c em.gro \
                  -r em.gro \
                  -p topol.top \
                  -po mdout_nvt_vac.mdp \
                  -o nvt_vac_${id}.tpr
    ${GMX} mdrun -deffnm nvt_vac_${id} -nsteps $MDSTEPS

elif [ $ENS = "nve" ]; then 
    echo "NVE runs..."
    cat templates/nve_vac.mdp | sed -e "s!#{RAND}!${RANDOM}!g" > nve_vac_${id}.mdp
    ${GMX} grompp -f nve_vac_${id}.mdp \
                  -c em.gro \
                  -r em.gro \
                  -p topol.top \
                  -po mdout_nve_vac.mdp \
                  -o nve_vac_${id}.tpr \
                  -maxwarn 1
    ${GMX} mdrun -deffnm nve_vac_${id} -nsteps $MDSTEPS

else
    echo "ERROR: ENS stores invalid value => $ENS"
fi
