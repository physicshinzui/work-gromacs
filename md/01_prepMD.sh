#!/bin/bash
set -Ceu

cat << EOS
Author: Shinji Iida
This script automates a system preparation for Gromacs.
    Usage:
        bash ${0} [PDB file] [Bounday type]
EOS

inputPDBName=$1 
BT=$2
proteinName=`basename ${inputPDBName%.*}`
GMX=gmx

${GMX} pdb2gmx -f ${inputPDBName} -o ${proteinName}_processed.gro -water tip3p

${GMX} editconf -f ${proteinName}_processed.gro \
              -o ${proteinName}_newbox.gro    \
              -d 1.0                          \
              -princ \
              -bt $BT
${GMX} solvate -cp ${proteinName}_newbox.gro \
             -cs spc216.gro                \
             -o ${proteinName}_solv.gro    \
             -p topol.top

${GMX} grompp -f ../templates/ions.mdp \
            -c ${proteinName}_solv.gro \
            -p topol.top \
            -po mdout_ion.mdp \
            -o ions.tpr

echo "SOL" | ${GMX} genion \
    -s ions.tpr \
    -o ${proteinName}_solv_ions.gro \
    -p topol.top \
    -pname NA -nname CL \
    -conc 0.1 -neutral 

echo "Energy minimisation 1 ..."
${GMX} grompp -f ../templates/em1.mdp \
            -c ${proteinName}_solv_ions.gro \
            -r ${proteinName}_solv_ions.gro \
            -p topol.top \
            -po mdout_em1.mdp \
            -o em1.tpr 
${GMX} mdrun -deffnm em1 

echo "Energy minimisation 2 ..."
${GMX} grompp -f ../templates/em2.mdp \
            -c em1.gro \
            -p topol.top \
            -po mdout_em2.mdp \
            -o em2.tpr 
${GMX} mdrun -deffnm em2
