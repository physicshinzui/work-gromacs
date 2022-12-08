#!/bin/bash 
set -Ceu

export GMX=gmx_d
## NVE in Vaccume 
echo 1 | ./00_vaccum.sh sample_pdb/decaAla.pdb 100000 nve 
echo "Total-Energy" |  $GMX energy -f nve_vac_1.edr -o totene.xvg >& log
cat log | grep -2 "Total Energy"
