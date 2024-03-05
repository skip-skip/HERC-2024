function [label] = LabelEvent(acfilts, name, default_label)
%LabelEvent Promp for user input to label the event. The event is saved
%according to the label. -1 for default indicates unlabeled by default.
%   Detailed explanation goes here
FOLDERS = ['./Avalanche_s/','./Avalanche_e/','./Explosion/','./Helicopter/','./Noise/','./Unlabeled/'];

label = input(['Enter key to specify a label:\n ' ...
    '[0] Default/None\n' ...
    '[1] Avalanche (short)\n' ...
    '[2] Avalanche (extended)\n' ...
    '[3] Explosion\n' ...
    '[4] Helicopter\n' ...
    '[5] Noise' ...
    '[6] Unlabeled']);
if label==0 
    label = default_label;
end
if label == -1
    label = 6;

folder = FOLDERS(label);
writematrix(acfilts, [folder name]);

end