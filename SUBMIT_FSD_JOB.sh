#!/bin/bash
#SBATCH -J FSD_RUNS #A single job name for the array
#SBATCH -o RUNS2to7 #Standard output
# #SBATCH -e MOV_%A_%a.err #Standard error
#SBATCH -p kuang_hp #Partition
#SBATCH -t 72:00:00 #Running time of 2 hours
#SBATCH --mem-per-cpu 12000 #Memory request
#SBATCH -n 1

module load centos6/matlab-R2014a >& /dev/null

export DISPLAY=

matlab -nodesktop -nosplash -nodisplay < Drive_Sens_CollMech.m
