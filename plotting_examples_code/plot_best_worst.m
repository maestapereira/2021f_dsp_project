%% Find best and worst files
% (criteria = min or max true positives).

% get_all_conf_mat
% clearvars -except all_TP directory
% get_best_worst_files

% Path has to be a stirng to a folder containing the image to be processed,
% in a .mat format. The folder must contain the file '30.mat', as it is
% used as a template to remove eyes.
path = strcat('C:\Users\smaes\OneDrive\to_be_desktop\', ...
    'columbia_masters\2021_f\dsp\dsp_project\2021f_dsp_project\data\tumor_data\');

% Get image to detect tumor from - CHANGE THIS TO THE DESIRED IMAGE

worst_path = 'C:\Users\smaes\OneDrive\to_be_desktop\columbia_masters\2021_f\dsp\dsp_project\2021f_dsp_project\figures\worst_figs\';
best_path = 'C:\Users\smaes\OneDrive\to_be_desktop\columbia_masters\2021_f\dsp\dsp_project\2021f_dsp_project\figures\best_figs\';

for worst_i = 1:size(worst_files, 1)
    imgInfo = load(append(path, worst_files{worst_i}));
    fig_num = worst_i;
    fig_name_found = strcat(worst_files{worst_i}(1:size(worst_files{worst_i}, 2)-4), '_filled_found.jpg');
    fig_name_actual = strcat(worst_files{worst_i}(1:size(worst_files{worst_i}, 2)-4), '_filled_actual.jpg');
    child_script_single_file
end

for best_i = 1:size(best_files, 1)
    imgInfo = load(append(path, best_files{best_i}));
    fig_num = worst_i + best_i;
    fig_name_found = strcat(best_files{best_i}(1:size(best_files{best_i}, 2)-4), '_filled_found.jpg');
    fig_name_actual = strcat(best_files{best_i}(1:size(best_files{best_i}, 2)-4), '_filled_actual.jpg');
    child_script_single_file
end