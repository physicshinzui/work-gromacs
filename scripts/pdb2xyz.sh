#!/bin/bash 

cat << EOF
Usage: 
    bash $0 [PDB] 

    Output:
        ref.xyz

EOF
echo 1 | gmx pdb2gmx -f $1 -o ref.pdb -water none
natoms=`grep ATOM ref.pdb | tail -n1 | awk '{print $2}'`
echo $natoms > ref.xyz
grep ATOM ref.pdb | awk '{print $2 " " $7 " " $8 " " $9}' >> ref.xyz
