#!/bin/bash 

ls *.gro *.tpr *# *.edr *.trr *.xtc *.top *.itp *.mdp *.log
read -p "Are you really sure?[Enter]"
read -p "Are you really sure?[Enter]"
rm -v *.gro *.tpr *# *.edr *.trr *.xtc *.top *.itp *.mdp *.log
