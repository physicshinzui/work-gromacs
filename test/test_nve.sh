#!/bin/bash 

## NVE in Vaccume 
echo 1 | ./00_vac_nvt.sh sample_pdb/decaAla.pdb 100000 nve >& log1
echo "Total-Energy" |  gmx energy -f nve_vac_1.edr -o totene.xvg >& log2
cat log2 | grep -2 "Total Energy"
