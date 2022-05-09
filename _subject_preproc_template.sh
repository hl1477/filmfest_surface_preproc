#! /bin/bash
# template script for preprocessing  
# hongmi lee 7/21/18

set -e

source _global.sh

SN=SUBJECTID

#####
#customize parameters here..
#####

# run freesurfer recon-all
if [[ $runreconall -eq 1 ]]; then
    source 1_run_recon_all.sh
fi

# run motion correction
if [[ $motioncorrect -eq 1 ]]; then
    source 2_run_mc.sh
fi

# run fieldmap preparation
if [[ $B0prep -eq 1 ]]; then
    source 3_run_b0prep.sh
fi

# run B0 unwarping
if [[ $B0unwarp -eq 1 ]]; then
    source 4_run_b0unwarp.sh
fi

# run freesurfer fsfast
if [[ $runfsfast -eq 1 ]]; then
    source 5_run_fsfast.sh
fi
