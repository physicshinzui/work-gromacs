#!/bin/bash
set -eu

function check_DB_paths() {  
    declare -p MOL_DB
    declare -p MDP_TEMPL
}

function add_cosolvent_topology() {
    ${GMX} insert-molecules -f ${proteinName}_solv.gro -ci $mol_pdb -nmol $nmol -replace SOL -o ${proteinName}_solv.gro > insert_molecule.log 2>&1
    no_excluded_molecules=`grep "Replaced" insert_molecule.log | awk '{print $2}'`
    #TODO: I want to add lines that put #include "ligand.itp" and "ligand 10" in topol.top
    #      Manual way:
    #      vim topol.top; :r ligand.itp; write "ligand NO_HERE" 
    no_sol=`tail -n10 topol.top | grep SOL | awk '{print $2}'`
    no_remaining_sol=`echo "$no_sol - $no_excluded_molecules" | bc`
    echo "#excluded molecules: $no_excluded_molecules"
    echo "#sol: $no_sol"
    echo "#remaining: $no_remaining_sol"
    read -p "TODO: #include itp , and modify no of SOL, and add no of ligand"
    
    ## Caution: not working yet
    sed 's/SOL *[0-9]\+/SOL $no_remaining_sol/' topol.top > tmp
    echo "LIG ${nmol}" >> tmp 
    mv tmp topol.top
    vim topol.top
}

cat << EOS
Author: Shinji Iida
This script automates a system preparation for Gromacs.
    Usage:
        bash ${0} [PDB file] [Bounday type]

NOTE: 
    export MOL_DB=path-to-molecules-database
    export MDP_TEMPL=path-to-mdp-templates
EOS

check_DB_paths

inputPDBName=$1 
BT=$2
proteinName=`basename ${inputPDBName%.*}`
GMX=gmx

is_mixed='true'

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

if $is_mixed; then
    read -p "How many molecules do you want to replace with water?" nmol
    echo "-- Available molecules --"
    ls ${MOL_DB}
    read -p "Type a name: " name
    mol_pdb=`ls ${MOL_DB}/${name}/*.pdb`

    add_cosolvent_topology

# NOTE: This line should work only when a ligand force field is previously made to be in a specified force field, e.g. amber99sb-ildn. 
# Assign force field parameters including the ligand by the following line
#    ${GMX} pdb2gmx -f ${proteinName}_solv.gro -water tip3p -o ${proteinName}_solv.gro
fi

${GMX} grompp -f ${MDP_TEMPL}/ions.mdp \
            -c ${proteinName}_solv.gro \
            -p topol.top \
            -po mdout_ion.mdp \
            -o ions.tpr

echo "SOL" | ${GMX} genion \
    -s ions.tpr \
    -o ${proteinName}_solv_ions.gro \
    -p topol.top \
    -pname NA -nname CL \
    -neutral 
    #-conc 0.1 -neutral 

echo "Energy minimisation 1 ..."
${GMX} grompp -f ${MDP_TEMPL}/em1.mdp \
            -c ${proteinName}_solv_ions.gro \
            -r ${proteinName}_solv_ions.gro \
            -p topol.top \
            -po mdout_em1.mdp \
            -o em1.tpr 
${GMX} mdrun -deffnm em1 

echo "Energy minimisation 2 ..."
${GMX} grompp -f ${MDP_TEMPL}/em2.mdp \
            -c em1.gro \
            -p topol.top \
            -po mdout_em2.mdp \
            -o em2.tpr 
${GMX} mdrun -deffnm em2
