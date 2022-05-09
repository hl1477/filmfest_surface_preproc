#! /bin/bash
# run motion correction (fsl mcflirt) 
# hongmi lee 7/19/18

# motion correction within each run (ref = first vol)
for (( run=0; run<${numruns}; run++)); do

#    RUN=00$((${run}+3))
    RUN=00$((${run}+1))
    RUN_DIR=${PROJECT_DIR}/${SN}/bold/${RUN}
                
    echo "Motion correction: Starting ${SN} run ${RUN} ..."

    # extract the first volume & brain extract
    fslroi ${RUN_DIR}/${runnames[${run}]} ${RUN_DIR}/example_func 0 1
    bet ${RUN_DIR}/example_func ${RUN_DIR}/example_func_brain -f $betparam -m 

    # motion correction to the first volume
    mcflirt -in ${RUN_DIR}/${runnames[${run}]} -out ${RUN_DIR}/r${runnames[${run}]} -refvol 0 -mats -plots -rmsrel -rmsabs -spline_final

    # generate motion outlier confound variables
    mkdir -p ${RUN_DIR}/motion

    fsl_motion_outliers -i ${RUN_DIR}/r${runnames[${run}]} -o ${RUN_DIR}/motion/motionoutlier_${RUN} -m ${RUN_DIR}/example_func_brain_mask -s ${RUN_DIR}/motion/motionoutlier_metric --nomoco --dvars

    # save movtion parameter plots
    fsl_tsplot -i ${RUN_DIR}/r${runnames[${run}]}.par -t 'MCFLIRT estimated rotations (radians)' -u 1 --start=1 --finish=3 -a x,y,z -w 640 -h 144 -o ${RUN_DIR}/motion/rot.png 

    fsl_tsplot -i ${RUN_DIR}/r${runnames[${run}]}.par -t 'MCFLIRT estimated translations (mm)' -u 1 --start=4 --finish=6 -a x,y,z -w 640 -h 144 -o ${RUN_DIR}/motion/trans.png 

    fsl_tsplot -i ${RUN_DIR}/r${runnames[${run}]}_abs.rms,${RUN_DIR}/r${runnames[${run}]}_rel.rms -t 'MCFLIRT estimated mean displacement (mm)' -u 1 -w 640 -h 144 -a absolute,relative -o ${RUN_DIR}/motion/disp.png 

    # move motion parameters
    mv ${RUN_DIR}/*.rms ${RUN_DIR}/motion
    mv ${RUN_DIR}/r${runnames[${run}]}.par ${RUN_DIR}/motion
    mv ${RUN_DIR}/r${runnames[${run}]}.mat ${RUN_DIR}/motion

done