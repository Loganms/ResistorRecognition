%% Sample Image Analysis

HIST_FOLDER = 'ColorSpaceHistograms/';
NUM_IMAGES = 33;

% choose color space: 
    % 1) RGB, 
    % 2) nRGB, 
    % 3) HSV,
    % 4) Lab,
    % 5) YCbCr
    % 6) YIQ (NTSC)
COLOR_SPACE = 2;
if (COLOR_SPACE == 1)
    CS_STRING = 'RGB';
elseif (COLOR_SPACE == 2)
    CS_STRING = 'nRGB';
elseif (COLOR_SPACE == 3)
    CS_STRING = 'HSV';
elseif (COLOR_SPACE ==4)
    CS_STRING = 'Lab';
elseif (COLOR_SPACE == 5)
    CS_STRING = 'YCbCr';
elseif (COLOR_SPACE == 6)
    CS_STRING = 'YIQ';
end

%% GET ALL FOREGROUND AND BACKGROUND COMPONENTS
[fg_all_comp_1, fg_all_comp_2,fg_all_comp_3,...
bg_all_comp_1, bg_all_comp_2, bg_all_comp_3] = get_all_fg_bg_components(COLOR_SPACE);

%% SHOW HISTS
figure
    if (COLOR_SPACE == 3)
        polarhistogram(fg_all_comp_1.*(2 * pi), 24);
    else
        imhist(fg_all_comp_1);
    end
    title([CS_STRING, ' Comp 1 fg']);
    saveas(gcf, [HIST_FOLDER, CS_STRING, '/', 'Comp 1 fg.png']);
    figure
    if (COLOR_SPACE == 3)
        polarhistogram(bg_all_comp_1.*(2 * pi), 24);
    else
        imhist(bg_all_comp_1);
    end
title([CS_STRING, ' Comp 1 bg']);
saveas(gcf, [HIST_FOLDER, CS_STRING, '/', 'Comp 1 bg.png']);

figure
imhist(fg_all_comp_2);
title([CS_STRING, ' Comp 2 fg']);
saveas(gcf, [HIST_FOLDER, CS_STRING, '/', 'Comp 2 fg.png']);
figure
imhist(bg_all_comp_2);
title([CS_STRING, ' Comp 2 bg']);
saveas(gcf, [HIST_FOLDER, CS_STRING, '/', 'Comp 2 bg.png']);

figure
imhist(fg_all_comp_3);
title([CS_STRING, ' Comp 2 fg']);
saveas(gcf, [HIST_FOLDER, CS_STRING, '/', 'Comp 3 fg.png']);
figure
imhist(bg_all_comp_3);
title([CS_STRING, ' Comp 3 bg']);
saveas(gcf, [HIST_FOLDER, CS_STRING, '/', 'Comp 3 bg.png']);