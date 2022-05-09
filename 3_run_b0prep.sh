#! /bin/bash
# prepare fieldmap images for unwarping (in case not done in the old pipeline)
# hongmi lee 11/16/18

FIELDMAP_DIR=${PROJECT_DIR}/${SN}/fieldmap
    
echo "Fieldmap preparation: Starting ${SN} ..."
    
#Merge the two fieldmap magnitude images into one 4d file
fslmerge -t ${FIELDMAP_DIR}/fieldmap_mag ${FIELDMAP_DIR}/fieldmap_mag01 ${FIELDMAP_DIR}/fieldmap_mag02

#Average the two fieldmap magnitude images (two are run for greater stability)
fslmaths ${FIELDMAP_DIR}/fieldmap_mag -Tmean ${FIELDMAP_DIR}/fieldmap_mag_mean

#BET extraction for resulting magnitude image
bet ${FIELDMAP_DIR}/fieldmap_mag_mean ${FIELDMAP_DIR}/fieldmap_mag_mean_brain -B -R -f $betparamb0 

# create fieldmap image in rad/sec
if [ $issiemens == 1 ]; then
    fsl_prepare_fieldmap SIEMENS ${FIELDMAP_DIR}/fieldmap_phase ${FIELDMAP_DIR}/fieldmap_mag_mean_brain ${FIELDMAP_DIR}/fieldmap_phase_radsec $deltaTE
fi

fugue --loadfmap=${FIELDMAP_DIR}/fieldmap_phase_radsec -s $smoothparamb0 --savefmap=${FIELDMAP_DIR}/fieldmap_phase_radsec_sm2