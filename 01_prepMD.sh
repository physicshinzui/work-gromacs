#!/bin/bash
set -Ceu

cat << EOS
Author: Shinji Iida
This script automates a system preparation for Gromacs.
    Usage:
        bash ${0} [PDB file]
EOS
GMX=/opt/homebrew/bin/gmx

inputPDBName=$1 
proteinName=`basename ${inputPDBName%.*}`

gmx pdb2gmx -f ${inputPDBName} -o ${proteinName}_processed.gro -water tip3p

gmx editconf -f ${proteinName}_processed.gro \
              -o ${proteinName}_newbox.gro    \
              -d 1.0                          \
              -bt dodecahedron #triclinic 

gmx solvate -cp ${proteinName}_newbox.gro \
             -cs spc216.gro                \
             -o ${proteinName}_solv.gro    \
             -p topol.top

gmx grompp -f templates/ions.mdp \
            -c ${proteinName}_solv.gro \
            -p topol.top \
            -o ions.tpr

echo "SOL" | gmx genion \
    -s ions.tpr \
    -o ${proteinName}_solv_ions.gro \
    -p topol.top \
    -pname NA -nname CL \
    -conc 0.1 -neutral 

echo "Energy minimisation 1 ..."
gmx grompp -f templates/em1.mdp \
            -c ${proteinName}_solv_ions.gro \
            -r ${proteinName}_solv_ions.gro \
            -p topol.top \
            -o em1.tpr 
gmx mdrun -deffnm em1 

echo "Energy minimisation 2 ..."
gmx grompp -f templates/em2.mdp \
            -c em1.gro \
            -p topol.top \
            -o em2.tpr 
gmx mdrun -deffnm em2
