#!/bin/bash

#Note: -extend time [ps]
prefix=npt_prod_1 #the prefix of run to be extended
gmx convert-tpr -s ${prefix}.tpr -extend 20000 -o ${prefix}.tpr
gmx mdrun -deffnm ${prefix} -s ${prefix}.tpr -cpi ${prefix}.cpt
