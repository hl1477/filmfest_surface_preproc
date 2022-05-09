#! /bin/bash
# setup global variables 
# hongmi lee 7/19/18

STORAGE_DIR=/storage/datapipe/filmfest/ffprism/subjects   # where original raw images are located
PROJECT_DIR=/scratch/hongmi/NarNet/fMRI/filmfest_surface/subjects   # new project directory
SUBJECTS_DIR=/scratch/hongmi/NarNet/fMRI/filmfest_surface/freesurfer # for freesurfer recon-all results

#mkdir -p ${SUBJECTS_DIR}
#mkdir -p ${PROJECT_DIR}

if [[ ! -d ${SUBJECTS_DIR}/fsaverage6 ]]; then
    cp -R ${FREESURFER_HOME}/subjects/fsaverage6 ${SUBJECTS_DIR}/fsaverage6   
fi

#ALL_SUBJECTS=( ANE_164234 FHK_144134 FKB_143634 FKC_142334 FUL_143434 JLW_182834 JNB_193933 JNB_194233 JNN_182234 JNN_193733 JNO_194133 JZQ_182934 MTU_151434 NOD_231733 NUX_231633 ONH_224233 SBS_213433 SKB_214033 SKG_214133 SLN_213333 SNE_213733 ) 
#ALL_SUBJECTS=( ANE_164234 FHK_144134 FKC_142334 JNB_193933 JNB_194233 JNN_193733 JNO_194133 JZQ_182934 MTU_151434 NOD_231733 NUX_231633 ONH_224233 SBS_213433 SKB_214033 SKG_214133 SLN_213333 SNE_213733 ) 
#ALL_SUBJECTS=( ANE_164234 FHK_144134 FKC_142334 JNB_193933 JNN_193733 JZQ_182934 MTU_151434 NOD_231733 NUX_231633 SKB_214033 SLN_213333 SNE_213733 ) 
#ALL_SUBJECTS=( JNB_194233 JNO_194133 ONH_224233 SBS_213433 SKG_214133 )
ALL_SUBJECTS=( SBS_213433 )

#runnames=( movie01 movie02 ) # name of functional runs
#runnames=( recall01 cuedrecall )
#runnames=( recall01 recall02 cuedrecall )
runnames=( movie01 movie02 recall01 recall02 cuedrecall )
numruns=${#runnames[@]} # number of functional runs

runreconall=0 # run freesurfer recon-all (0=do not run)

motioncorrect=1 # run fsl motion correction (0=do not run)
betparam=0.3 # f value for bet brain extraction

B0prep=1 # prepare fieldmap images (0=do not run)
betparamb0=0.5 # f value for bet brain extraction of fieldmap mag images
issiemens=1 # siemens scanner was used to collect the data (0=not siemens)
deltaTE=2.46 # usually 2.46 for siemens scanners
smoothparamb0=2.0 # phase smoothing parameter (sigma in mm) 

B0unwarp=1 # run fsl fieldmap unwarping (0=do not run)
dwelltime=0.00092 # echo spacing in seconds

runfsfast=1 # run freesurfer fsfast-normalization, registraion, smoothing (0=do not run)
smoothparam=4 # smoothing fwhm