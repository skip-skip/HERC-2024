function [label] = LabelEvent(acfilts, names, default_label, fig, fig_name)
%LabelEvent Promp for user input to label the event. The event is saved
%according to the label. -1 for default indicates unlabeled by default.
%   Detailed explanation goes here
FOLDERS = {'Avalanche_s','Avalanche_e','Explosion','Helicopter','Noise','Unlabeled'};



if ~isnan(default_label)
label = input(['Enter key to specify a label:\n' ...
    '[0] Default/None\n' ...
    '[1] Avalanche, short\n' ...
    '[2] Avalanche, extended\n' ...
    '[3] Explosion\n' ...
    '[4] Helicopter\n' ...
    '[5] Noise\n' ...
    '[6] Unlabeled\n']);
else
    label=0;
end
if label==0
    if isnan(default_label)
        default_label = -1;
    end
    switch default_label
        case -1
            label = 5;
        case {0, 1}
            label = 6;
        case {10, 20, 30}
            label = 1;
        case {11, 21, 31}
            label = 2;
        case {22}
            label = 4;
        case {23}
            label = 3;
    end
end
if label == -1
    label = 6;
end
folder = FOLDERS{label};
for i=1:size(acfilts, 2)
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    addpath(folder);
    data_path = fullfile(folder, [names{i} '.csv']);
    disp(['Saving: ' names{i}]);
    writematrix(acfilts(:,i), data_path);
    disp('Saved.');
end
fig_path = fullfile(folder, [fig_name '.png']);
saveas(fig, fig_path);
end