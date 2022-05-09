function [dispsubj, maxdisp, transsubj, maxtrans, rotsubj, maxrot, outliersubj, outlierTR] ...
    = post_fsfast_checkmotion(subjects,dispthr,transthr,rotthr,outlierthr)
% post_fsfast_checkmotion.m
% load 6 motion parameters and outlier files to examine motion artifacts 
% inputs
% - subjects = cell containing subject IDs (e.g.{'ANE_164234','FHK_144134'})
% - dispthr = absolute displacement threshold in mm. default 2mm
% - transthr = translation exclusion threshold in mm. default 2mm
% - rotthr = rotation exclusion threshold in rad. default 0.02
% - outlierthr = number of outlier TRs exclusion threshold. default 100
% outputs
% - dispsubj = subjects to be excluded based on absolute displacement
% - maxdisp = maximum absolute displacement per run in mm (subj X run)
% - transubj = subjects to be excluded based on translation motion
% - maxtrans = maximum translation per run in mm (subj X run X direction)
% - rotsubj = subjects to be excluded based on rotation motion
% - maxrot = maximum rotation per run in radians (subj X run X direction)
% - outliersuj = subjects to be excluded based on the number of motion outlier TRs
% - outlierTR = motion outlier TR indices for each run (subj X run cell)

% hongmi lee 7/28/18

if nargin < 2
   dispthr = 2;
   transthr = 2;
   rotthr = 0.02;
   outlierthr = 100;
elseif nargin < 3
   transthr = 2;
   rotthr = 0.02;
   outlierthr = 100;
elseif nargin < 4
   rotthr = 0.02;
   outlierthr = 100;    
elseif nargin < 5
   outlierthr = 100;  
end

PROJECT_DIR = '/scratch/hongmi/NarNet/fMRI/filmfest_surface/subjects';

%runnames = {'movie01', 'movie02','recall01','recall02','cuedrecall'}; % run names (raw functional image names)
runnames = {'movie01', 'movie02','recall01','cuedrecall'}; % run names (raw functional image names)

maxdisp = zeros(numel(subjects),numel(runnames));
maxtrans = zeros(numel(subjects),numel(runnames),3);
maxrot = zeros(numel(subjects),numel(runnames),3);
outlierTR = cell(numel(subjects),numel(runnames));
outliernum = zeros(numel(subjects),numel(runnames));

dispsubjnum = [];
transsubjnum = [];
rotsubjnum = [];
outliersubjnum = [];

for i = 1:numel(subjects)
    
    SN = subjects{i};
        
    for r = 1:numel(runnames)
        
        RUN = ['00' num2str(r)];
      
        absdisp = load(fullfile(PROJECT_DIR,SN, 'bold',RUN,'motion',['r' runnames{r} '_abs.rms']));
        maxdisp(i,r) = max(absdisp);
        
        params = load(fullfile(PROJECT_DIR,SN, 'bold',RUN,'motion',['r' runnames{r} '.par']));
        maxvals = max(params);
       
        maxrot(i,r,:) = maxvals(1:3);
        maxtrans(i,r,:) = maxvals(4:6);
        
        outlier = load(fullfile(PROJECT_DIR,SN, 'bold',RUN,'motion',['motionoutlier_' RUN]));
        [rows,~] = find(outlier);
        
        outlierTR{i,r} = rows;
        outliernum(i,r) = numel(rows);
    end
    
    % exclude subject exceeding the threshold in any one direction/run
    if ~isempty(find(maxdisp(i,:) > dispthr))
        dispsubjnum = [dispsubjnum i];
    end
    if ~isempty(find(maxtrans(i,:,:) > transthr))
        transsubjnum = [transsubjnum i];
    end
    if ~isempty(find(maxrot(i,:,:) > rotthr))
        rotsubjnum = [rotsubjnum i];
    end
    if ~isempty(find(outliernum(i,:) > outlierthr))
        outliersubjnum = [outliersubjnum i];
    end
    
end

dispsubj = subjects(dispsubjnum);
transsubj = subjects(transsubjnum);
rotsubj = subjects(rotsubjnum);
outliersubj = subjects(outliersubjnum);

end

