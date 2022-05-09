#! /bin/bash
# run fieldmap correction (fsl fugue)  
# hongmi lee 7/19/18

FIELDMAP_DIR=${PROJECT_DIR}/${SN}/fieldmap
    
# forward warp the mag volume  
fugue -i ${FIELDMAP_DIR}/fieldmap_mag_mean_brain --loadfmap=${FIELDMAP_DIR}/fieldmap_phase_radsec_sm2 --unwarpdir=y- --dwell=${dwelltime} -w ${FIELDMAP_DIR}/fieldmap_mag_mean_brain_warped 

for (( run=0; run<${numruns}; run++)); do
    
    RUN=00$((${run}+1))  
    RUN_DIR=${PROJECT_DIR}/${SN}/bold/${RUN}
    
    echo "B0 unwarping: Starting ${SN} run ${RUN} ..."
                
    # register the forward warped mag with the example func brain
    flirt -in ${FIELDMAP_DIR}/fieldmap_mag_mean_brain_warped -ref ${RUN_DIR}/example_func_brain -out ${FIELDMAP_DIR}/fieldmap_mag_mean_brain_warped_${RUN} -omat ${FIELDMAP_DIR}/fieldmap_mag_to_func_${RUN}.mat -dof 6
                        
    # resample fieldmap phase to epi space
    flirt -in ${FIELDMAP_DIR}/fieldmap_phase_radsec_sm2 -ref ${RUN_DIR}/example_func_brain -applyxfm -init ${FIELDMAP_DIR}/fieldmap_mag_to_func_${RUN}.mat -out ${FIELDMAP_DIR}/fieldmap_radsec_sm2_to_func_${RUN} -interp spline 

    # dewarp the epi
    fugue -i ${RUN_DIR}/r${runnames[${run}]} --loadfmap=${FIELDMAP_DIR}/fieldmap_radsec_sm2_to_func_${RUN} --unwarpdir=y- --dwell=${dwelltime} -u ${RUN_DIR}/f 
                  
done
        