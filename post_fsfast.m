function post_fsfast(numcore)
% post_fsfast.m
% numcore = number of cores to be used for parallel computing
% load the functional images resampled & smoothed on the fsaverage6 surface, 
% and save as vertex X TR .mat files (no furter filtering)
% hongmi lee 10/17/18

FREESURFER_DIR = '/usr/local/freesurfer';
PROJECT_DIR = '/scratch/hongmi/NarNet/fMRI/filmfest_surface/subjects';

% all subjects
% subjects = {'ANE_164234','FHK_144134','FKB_143634','FKC_142334','FUL_143434',...
%     'JLW_182834','JNB_193933','JNB_194233','JNN_182234','JNN_193733','JNO_194133',...
%     'JZQ_182934','MTU_151434','NOD_231733','NUX_231633','ONH_224233','SBS_213433',...
%     'SKB_214033','SKG_214133','SLN_213333','SNE_213733'};

%  subjects = {'ANE_164234', 'FHK_144134', 'FKC_142334', 'JNB_193933', 'JNB_194233', ...
%         'JNN_193733', 'JNO_194133', 'JZQ_182934', 'MTU_151434', 'NOD_231733', 'ONH_224233', ...
%         'NUX_231633', 'SBS_213433', 'SKB_214033', 'SKG_214133', 'SLN_213333', 'SNE_213733'};
%    
% subjects = {'ANE_164234', 'FHK_144134', 'FKC_142334', 'JNB_193933', 'JNN_193733',...
%     'JZQ_182934', 'MTU_151434', 'NOD_231733', 'NUX_231633', 'SKB_214033', 'SLN_213333', 'SNE_213733'};
%%
subjects = {'JNB_194233', 'JNO_194133', 'ONH_224233', 'SBS_213433', 'SKG_214133'};
%%
runs = {'005'}; %,{'001', '002', '003', '004'}; %  run names
surfacefiles = {'fmcpr.sm4.fsaverage6.lh.nii.gz','fmcpr.sm4.fsaverage6.rh.nii.gz'};

parpool(numcore);
parfor s = 1:numel(subjects)
    try
        run_hpf(PROJECT_DIR,FREESURFER_DIR,subjects{s},runs,surfacefiles);
    catch e
        fprintf('\n*****\nERROR!!!! : %s\n******\n',e.message);
    end
end
delete(gcp('nocreate'))

end

function run_hpf(PROJECT_DIR,FREESURFER_DIR,SN,runs,surfacefiles)

% load freesurfer matlab toolbox
addpath(genpath([FREESURFER_DIR '/matlab']));

for r = 1:numel(runs)
    
    RUN = runs{r};
    
    % surface image- left hemisphere
    surface_left = load_nifti(fullfile(PROJECT_DIR,SN,'bold',RUN,surfacefiles{1}));
    epi = squeeze(surface_left.vol);
    clear surface_left
    eval(['save ' fullfile(PROJECT_DIR,SN,'bold',RUN,'surface_left_unfiltered.mat') ' epi']);
    clear epi
    
    % surface image- right hemisphere
    surface_right = load_nifti(fullfile(PROJECT_DIR,SN,'bold',RUN,surfacefiles{2}));
    epi = squeeze(surface_right.vol);
    clear surface_right
    eval(['save ' fullfile(PROJECT_DIR,SN,'bold',RUN,'surface_right_unfiltered.mat') ' epi']);
    clear epi
    
end

end
