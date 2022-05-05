#!/bin/bash

##Setup environment
source /cvmfs/eel.gsi.de/centos7-x86_64/bin/go4login
export ROOT_INCLUDE_PATH=/lustre/gamma/cjones/DESPEC_S452_MHTDC
echo "DESPEC Kronos Started at `date`"

##Set data location
#dpath=~/lustre/gamma/d004/ts/aida/

LISTFILE="/lustre/gamma/cjones/DESPEC_S452_MHTDC/Cluster_Submission/file_list_full_188Ta.txt"

##Count number of files
NFILES=$(cat ${LISTFILE} | wc -l)
echo "Analysing" $NFILES "Files"

##Read names from list file
declare -a array
while IFS= read -r line
do
    array+=($line)
done < "$LISTFILE"

echo "Array is $SLURM_ARRAY_TASK_ID"
part=(  "${array[@]:$SLURM_ARRAY_TASK_ID:5}" ) # :5 number of files to put together -> Has to be the same in the 2 .sh scripts

echo "Running Go4!"
go4analysis -file ${part[*]} -enable-asf 1800 -asf /lustre/gamma/cjones/DESPEC_S452_MHTDC/Cluster_Submission/Nearline_Histograms/ANALY18_allTa_$SLURM_ARRAY_TASK_ID.root
