#! /bin/bash
# setup folder structure, copy & paste raw images, prepare subject-specific preproc scripts 
# hongmi lee 7/19/18

set -e

source _global.sh

nsubject=${#ALL_SUBJECTS[@]}

for (( i=0; i<${nsubject}; i++)); do

    SN=${ALL_SUBJECTS[i]}
    
    echo "copying...... ${SN}"

    # copy MPRAGE
    mkdir -p ${PROJECT_DIR}/${SN}/anatomical
    cp ${STORAGE_DIR}/${SN}/analysis/preproc/preproc01.feat/reg/highres_head.nii.gz ${PROJECT_DIR}/${SN}/anatomical/T1.nii.gz

    # copy functional images   
    for (( run=0; run<${numruns}; run++)); do

        RUN=00$((${run}+1))
        mkdir -p ${PROJECT_DIR}/${SN}/bold/${RUN}  
        
        cp ${STORAGE_DIR}/${SN}/data/nifti/${SN}_ff${runnames[${run}]}.nii.gz ${PROJECT_DIR}/${SN}/bold/${RUN}/${runnames[${run}]}.nii.gz
   
    done

    # copy fieldmaps (if exist)
    if [ -e ${STORAGE_DIR}/${SN}/data/nifti/${SN}_fieldmap_mag_mean_brain.nii.gz ]; then
        mkdir -p ${PROJECT_DIR}/${SN}/fieldmap
        cp ${STORAGE_DIR}/${SN}/data/nifti/${SN}_fieldmap_mag_mean_brain.nii.gz ${PROJECT_DIR}/${SN}/fieldmap/fieldmap_mag_mean_brain.nii.gz
        cp ${STORAGE_DIR}/${SN}/data/nifti/${SN}_fieldmap_phase_radsec_sm2.nii.gz ${PROJECT_DIR}/${SN}/fieldmap/fieldmap_phase_radsec_sm2.nii.gz        
    fi

    # create subjectname txt file
    echo $SN >> ${PROJECT_DIR}/${SN}/subjectname

     # create runlist txt file (specifies runs to preprocess)
     for (( run=0; run<${numruns}; run++)); do
        RUN=00$((${run}+1))     
        echo $RUN >> ${PROJECT_DIR}/${SN}/bold/runlistfile
     done
    
    # create subject-specific script (can be customized)
    for line in '_subject_preproc_template.sh'; do
        sed -e 's@SUBJECTID@'$SN'@g' <$line> preproc_${SN}.sh
    done
    
    chmod +x preproc_${SN}.sh
    echo "File preproc_${SN}.sh created"
    
done 

