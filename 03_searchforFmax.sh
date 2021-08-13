##!/bin/bash
set -Ceu
f_start=50
f_end=650
logfile=autocheck_log
touch ${logfile}
summary_file="pull_summary.csv"

# Binary search for Fmax
while [ $((f_end-f_start)) -gt 4 ]
do
    f_mid=$(( ($f_start+$f_end)/2 ))
    echo "f_start=${f_start}, f_end=${f_end}, f_mid=${f_mid}" >> ${logfile}
    cat templates/smd_Fmax.mdp | sed -e "s!#{FORCE_CONST}!${f_mid}!g"| grep "pull_coord1_k" > pull_k${f_mid}.mdp

    # gmx grompp -f pull_${f_mid}.mdp -c npt_eq_${id}.gro -o pull -p topol.top -n index.ndx -maxwarn 1
    # mdrun -v -deffnm pull -px pull_${f_mid}.xvg -pf pull_${f_mid}.xvg -ntmpi 1 -ntomp 20 >& pull_${f_mid}.job

    outfile=pull_${f_mid}.gro 

    if test -f "$outfile" ; then
        echo ".gro file was generated when pull force = ${f_mid}" >> ${logfile}
        f_start=$f_mid

    else
        echo "NO .gro file was generated when pull force = ${f_mid}" >> ${logfile}
        f_end=$f_mid
    fi

    # if f_end - f_start == 4, output the f_start value (aka Fmax) to summary file
    if [ $((f_end-f_start)) -le 4 ]; then
        echo "autocheck-1, ${f_start}" >> ${summary_file}
    fi

done
