#!/bin/bash
set -eu

cat << EOS
Author: Shinji Iida
This script automates a system preparation for Gromacs.
    Usage:
        bash ${0} [PDB file] [MD STEPS]
EOS

inputPDBName=$1
MDSTEPS=$2
proteinName=`basename ${inputPDBName%.*}`
GMX=gmx

${GMX} pdb2gmx -f ${inputPDBName} -o ${proteinName}_processed.gro -water tip3p

${GMX} editconf -f ${proteinName}_processed.gro \
              -o ${proteinName}_newbox.gro \
              -box 1000.0 1000.0 1000.0 \
              -bt cubic

echo "Energy minimisation 1 ..."
${GMX} grompp -f templates/em_vac.mdp \
            -c ${proteinName}_newbox.gro \
            -r ${proteinName}_newbox.gro \
            -p topol.top \
            -po mdout_em.mdp \
            -o em.tpr
${GMX} mdrun -deffnm em

echo "NVT equilibration runs are running..."
id=1
cat templates/nvt_vac.mdp | sed -e "s!#{RAND}!${RANDOM}!g" > nvt_vac_${id}.mdp
${GMX} grompp -f nvt_vac_${id}.mdp \
              -c em.gro \
              -r em.gro \
              -p topol.top \
              -po mdout_nvt_vac.mdp \
              -o nvt_vac_${id}.tpr
${GMX} mdrun -deffnm nvt_vac_${id} -nsteps $MDSTEPS
