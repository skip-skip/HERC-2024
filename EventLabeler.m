addpath('./util');
addpath('./MATS/');

wl = 500; ol = 400; dtmax = 24;
STRT_OFFSET = -60*20; %20 minutes
END_OFFSET = 60*20;

event_catalog = importEventCatalog("event_stats.txt",10);
event_dates = unique(dateshift(event_catalog.DateTime,'start','day'))';

for d = event_dates
    day_file = ['data', datestr(d, 'yyyymmmdd'), '.mat'];
    disp(['Loading: ' day_file]);
    load(day_file)
    
    disp('Pairwise correlating first array...');
    [corrs1,samples1,timelags1,P1] = pairwiseCorrelofast(acfilts(:,:,2),wl,ol,dtmax); %LCC2
    disp('Pairwise correlating second array...');
    [corrs2,samples2,timelags2,P2] = pairwiseCorrelofast(acfilts(:,:,3),wl,ol,dtmax); %LCC3
    disp('Finding mean correlation...');
    corrs_mean = (mean(corrs1, 3) + mean(corrs2, 3)) / 2;

    %average corrs here
    events = event_catalog(year(event_catalog.DateTime) == year(d) & ...
                         month(event_catalog.DateTime) == month(d) & ...
                         day(event_catalog.DateTime) == day(d), :);

    for row = 1:height(events)
        e = events(row,:);
        %       -plot start to start+hr or so
        disp(['Displaying event at: ' datestr(e.DateTime)]);
        frame_start = 3600*hour(e.DateTime) + 60*minute(e.DateTime) + STRT_OFFSET;
        frame_end = 3600*hour(e.DateTime) + 60*minute(e.DateTime) + END_OFFSET;
        if frame_start<1 
            frame_start = 1;
        end
        if frame_end>size(corrs_mean,2) 
            frame_start = size(corrs_mean,2);
        end        
        corrs_mean_frame = corrs_mean(:, frame_start:frame_end);
        cth = .25;
        corrs_mean_frame(corrs_mean_frame<cth) = 0;

        [frame_start, frame_end] = DisplayFrame(corrs_mean_frame, frame_start, frame_end)
        LabelEvent()
        %       -read input to adjust time range and plot
        %       confirm time range:
        %           -subset data
        %           -save data in labeled folder
        %           -save correlogram in extra folder
    end

    return

end

