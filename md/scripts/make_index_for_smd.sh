#!/bin/bash 
set -Ceu

echo
echo "###############################################################"
echo "Select 'reg1' and 'reg2' to define a reaction coordinate."
echo "###############################################################"
read -p 'Continue[enter]'

GMX=gmx
GRO=$1
$GMX make_ndx -f $GRO -o index.ndx
