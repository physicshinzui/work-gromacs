#!/bin/bash
set -Ceu
cat<<EOF

Usage: 
    $0 [PDB file] [box type] [No of runs]

- PDB file: used as the directory name where data is stored.
- box type: dodecahedron / triclinic / cubic
- No of runs (int)

EOF
readonly PDB=`pwd`/$1
readonly prefix=`basename ${PDB%.*}`
readonly BT=$2
readonly N=$3
