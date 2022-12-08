#!/bin/bash
set -eu

cat<<EOF

Usage: 
    $0 [PDB file]

Note that the prefix of the given PDB file name is used in naming md jobs.

EOF
PDB=$1
prefix=`basename ${PDB%.*}`
echo $prefix
bash 01_prepMD.sh $PDB
bash 02_eq.sh $prefix
bash 03_md_prod.sh $prefix
