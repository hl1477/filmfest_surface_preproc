#! /bin/bash
# check epi-T1 registration   
# hongmi lee 9/27/18

set -e

source _global.sh

cd $PROJECT_DIR

SUBJECTS=( SBS_213433 ) #ANE_164234 FHK_144134 FKB_143634 FKC_142334 FUL_143434 JLW_182834 JNB_193933 JNB_194233 JNN_182234 JNN_193733 JNO_194133 JZQ_182934 MTU_151434 NOD_231733 NUX_231633 ONH_224233 SBS_213433 SKB_214033 SKG_214133 SLN_213333 SNE_213733 ) 
nsubject=${#SUBJECTS[@]}

for (( i=0; i<${nsubject}; i++)); do

    SN=${SUBJECTS[i]}
    tkregister-sess -s $SN -fsd bold -per-run -bbr-sum 
done

## to show T1 & epi images, type something like below in terminal
#tkregister-sess -s ANE_164234 -fsd bold -per-run 