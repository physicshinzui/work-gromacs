#!/bin/bash 

export GMX=gmx
## NVE in Vaccume 
echo 1 | ./00_vaccum.sh sample_pdb/decaAla.pdb 100000 nve >& /dev/null
echo "Total-Energy" |  $GMX energy -f nve_vac_1.edr -o totene.xvg >& log
cat log | grep -2 "Total Energy"
