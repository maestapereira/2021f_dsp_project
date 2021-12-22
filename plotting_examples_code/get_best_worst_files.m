%% Find best and worst files
% (criteria = min or max true positives).

worst_idx = find(all_TP == 0)+2;

worst_files = cell(10, 1);
worst_files{1} = directory(worst_idx(1)).name;
worst_files{2} = directory(worst_idx(2)).name;
worst_files{3} = directory(worst_idx(3)).name;
worst_files{4} = directory(worst_idx(4)).name;
worst_files{5} = directory(worst_idx(5)).name;
worst_files{6} = directory(worst_idx(6)).name;
worst_files{7} = directory(worst_idx(7)).name;
worst_files{8} = directory(worst_idx(8)).name;
worst_files{9} = directory(worst_idx(9)).name;
worst_files{10}=directory(worst_idx(10)).name;

best_idx = find(all_TP == max(all_TP))+2;

best_files = cell(1, 1);
best_files{1} = directory(best_idx(1)).name;
