#! /bin/bash
# rename/remove files

set -e
PROJECT_DIR=/scratch/hongmi/NarNet/fMRI/filmfest_surface/subjects

ALL_SUBJECTS=( ANE_164234 FHK_144134 FKC_142334 JNB_193933 JNN_193733 JZQ_182934 MTU_151434 NOD_231733 NUX_231633 SKB_214033 SLN_213333 SNE_213733 JNB_194233 JNO_194133 ONH_224233 SKG_214133 ) #SBS_213433 
runnames=( 001 002 )
#ALL_SUBJECTS=( FKC_142334 JNB_194233 JNN_193733 JNO_194133 JZQ_182934 ONH_224233 SKB_214033 SLN_213333 SNE_213733 )    
#ALL_SUBJECTS=( ANE_164234 FHK_144134 JNB_193933 MTU_151434 NOD_231733 NUX_231633 SBS_213433 SKG_214133 )
#ALL_SUBJECTS=( JNB_194233 JNO_194133 ONH_224233 SBS_213433 SKG_214133 )
#runnames=( 005 )
#ALL_SUBJECTS=( FKB_143634 FUL_143434 JLW_182834 JNN_182234 )
#runnames=( 001 002 )

nsubject=${#ALL_SUBJECTS[@]}
numruns=${#runnames[@]} # number of functional runs

for (( i=0; i<${nsubject}; i++)); do

    SN=${ALL_SUBJECTS[i]}
    
    echo "working on...... ${SN}"
    
#    mv ${PROJECT_DIR}/${SN}/bold/movie_SRM_group2 ${PROJECT_DIR}/${SN}/bold/_oldfiltering_movie_SRM_group2

    for (( run=0; run<${numruns}; run++)); do

        RUN=00$((${run}+1))        
        
        mv ${PROJECT_DIR}/${SN}/bold/${runnames[${run}]}/roitc ${PROJECT_DIR}/${SN}/bold/${runnames[${run}]}/_oldcropping3TR_roitc
#   
#        rm ${PROJECT_DIR}/${SN}/bold/${runnames[${run}]}/surface_left.mat
#        rm ${PROJECT_DIR}/${SN}/bold/${runnames[${run}]}/surface_right.mat
#        rm ${PROJECT_DIR}/${SN}/bold/${runnames[${run}]}/surface_left_filtered*.mat 
#        rm ${PROJECT_DIR}/${SN}/bold/${runnames[${run}]}/surface_right_filtered*.mat 
#        rm -r ${PROJECT_DIR}/${SN}/bold/${runnames[${run}]}/roitc
    done
    
done 
