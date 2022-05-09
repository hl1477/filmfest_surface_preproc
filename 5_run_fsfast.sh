#! /bin/bash
# run freesurfer fsfast registration, normalization, and smoothing on the motion & B0 corrected functional images
# hongmi lee 7/20/18

cd ${PROJECT_DIR}

echo "FsFast: Starting ${SN} ..."

for (( run=0; run<${numruns}; run++)); do

    RUN=00$((${run}+1))
    RUN_DIR=${PROJECT_DIR}/${SN}/bold/${RUN}
    
    #if B0 unwarping was not applied, save motion corrected images as f.nii.gz
    if [[ ! -e ${RUN_DIR}/f.nii.gz ]]; then
        echo "B0 unwarpped images not found. Use motion corrected images instead: ${SN} run ${RUN} ..."
        mv ${RUN_DIR}/r${runnames[${run}]}.nii.gz ${RUN_DIR}/f.nii.gz
    fi
    
    if [[ ! -e ${RUN_DIR}/fmcpr.nii.gz ]]; then
        cp ${RUN_DIR}/f.nii.gz ${RUN_DIR}/fmcpr.nii.gz 
    fi
done

preproc-sess -s ${SN} -fsd bold -surface fsaverage6 lhrh -mni305-2mm -fwhm $smoothparam -per-run -nomc -nostc -noinorm -no-subcort-mask -rlf runlistfile