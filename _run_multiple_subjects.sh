#! /bin/bash
# run preprocessing for all selected subjects (serially, on a single screen)
# hongmi lee 7/26/18

set -e

SCRIPTS_DIR=/scratch/hongmi/NarNet/fMRI/filmfest_surface/scripts_preproc

SUBJECTS=( JNB_194233 JNO_194133 ONH_224233 SBS_213433 SKG_214133 )

for (( i=0; i<${#SUBJECTS[@]}; i++)); do
    
    cd ${SCRIPTS_DIR}
    source preproc_${SUBJECTS[i]}.sh
    
done