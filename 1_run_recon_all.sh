#! /bin/bash
# run freesurfer recon-all 
# hongmi lee 7/19/18

echo "Recon-all: Starting ${SN} ..."
    
recon-all -i ${PROJECT_DIR}/${SN}/anatomical/T1.nii.gz -subject $SN -all 