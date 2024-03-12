function [frame_start,frame_end, fig] = DisplayFrame(corrs,frame_start, frame_end)
%DisplayFrame Displays a correlogram within a certain frame.
%   The frame can be shifted left or right, and can be zoomed in or out. 
%   The bounds of the frame can be manually selected by clicking the figure
    FRAME_ZOOM_INC = 60; %one minute
    FRAME_SHIFT_INC = 60;

    done = false;
    cth = .25;
    lines = [-1,-1];
    while ~done
        if frame_start<1 
            frame_start = 1;
        end
        if frame_end>size(corrs,2) 
            frame_end = size(corrs,2);
        end

        corrs_frame = corrs(:, frame_start:frame_end);
        corrs_frame(corrs_frame<cth) = 0;
        
        clf;

        fig = imagesc(1, size(corrs_frame,2),corrs_frame);
        xticklabels(frame_start+100:100:frame_end+100);
        colormap('jet');
        hold on;
        if lines(1)>0
            line([lines(1), lines(1)], ylim, 'Color', 'red', 'LineWidth', 2);
        end
        if lines(2)>0
            line([lines(2), lines(2)], ylim, 'Color', 'red', 'LineWidth', 2);
        end
        hold off;

        keypress = waitforbuttonpress;
        input = '';
        if keypress
            input = gcf().CurrentCharacter;
        end
        switch input
            case {'w', char(30)}

                if lines(1) > 0 && lines(2) > 0
                    base=frame_start;
                    frame_start = min(lines)+base;
                    frame_end = max(lines)+base;
                elseif frame_start+FRAME_ZOOM_INC < frame_end-FRAME_ZOOM_INC
                    frame_start = frame_start+FRAME_ZOOM_INC;
                    frame_end = frame_end-FRAME_ZOOM_INC;
                end
                lines = [-1,-1];
            case {'s', char(31)}

                frame_start = frame_start-FRAME_ZOOM_INC;
                frame_end = frame_end+FRAME_ZOOM_INC;
                lines = [-1,-1];
            case {'a', char(28)}
                if frame_start == 1
                    continue;
                end

                frame_start = frame_start-FRAME_SHIFT_INC;
                frame_end = frame_end-FRAME_SHIFT_INC;
                lines = [-1,-1];
            case {'d', char(29)}
                if frame_end == size(corrs,2)
                    continue;
                end
                frame_start = frame_start+FRAME_SHIFT_INC;
                frame_end = frame_end+FRAME_SHIFT_INC;
                lines = [-1,-1];
            case 'x'
                done=true;
            otherwise
                if keypress
                    continue;
                end
                [x,~] = ginput(1);
                if lines(1) < 0
                    lines(1) = round(x);
                elseif lines(2) < 0
                    lines(2) = round(x);
                else
                    lines = [-1,-1];
                end
        end

    end
end