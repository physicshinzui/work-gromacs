#!/bin/bash
set -eu

GMX=gmx_plumed
id=1

${GMX} mdrun -deffnm npt_metad_${id} \
             -cpi npt_metad_${id}.cpt \
             -nsteps 1000 \
             -plumed plumed_rg_rest.dat

# NOTE:
# `-nsteps N` extends N steps from the checkpoint file
# `-cpi` is required to restart a simulation from the checkpoint (stored in .cpt file)
# `-plumed` needs a almost identical plumed.dat file used in the previous simulation.
#    The difference is only the line: RESTART=YES.
#    This enables PLUMED to append data to HILLS and COLVAR.
