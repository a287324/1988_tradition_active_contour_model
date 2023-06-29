clearvars; clc; close all;
format compact;
% 基本公設說明
% 原點為左上角，且橫軸是x軸,而縱軸是y軸(為了不與影像的軸向搞混)

% 參數設置
para.testimg = 'test_data\circle.jpg';
para.getNewContour = false;      % 是否重新設定輪廓、物件、背景點
para.displayFext = false;        % 是否顯示外部能量
para.displayContour = true;     % 是否顯示輪廓迭代的過程
    % snake參數
para.Iteration = 100;   % 迭代次數
para.Nc = 100;          % 輪廓點數量
para.alpha = 0.5;         % continuity
para.beta = 0;          % smoothness
para.gamma = 1;         % step size
para.Wline = 0;         % Eline：snake will be attracted either to light lines or dark lines.
para.Wedge = 2;         % Eedge：snake is attracted to contours with large image gradients.
para.Wterm = 0;         % Eterm：snake is attracted to terminations of line segments and corners.

% step 1: 讀取影像
im = imread(para.testimg);
if size(im, 3) == 3
	im = rgb2gray(im);
    im = im2double(im);
else
    im = im2double(im);
end
[para.im_row, para.im_col] = size(im);

% step 2: 設置輪廓點(C)和物件點(O)
if para.getNewContour
    P = GetFeaturePoint(im, para.Nc);    % 使用者自訂輪廓點和物件點
else
    load('parameter\contour_and_object.mat');   % 使用上一次使用者自訂的輪廓點和物件點
    P.Contour = MakeContourClockwise2D(P.Contour);          % 確保輪廓點是順時針
	P.Contour = InterpolateContourPoints2D(P.Contour, para.Nc);  % 輪廓點插值
end

% step 3: 設置內部能量的矩陣
B = getInternalForceMatrix(para.Nc, para.alpha, para.beta, para.gamma);

% figure();   imshow(im);
% step 4: 外部能量
Fext = getExternelForce(im, para.Wline, para.Wedge, para.Wterm);
if para.displayFext
    figure();   
    imshow(im); hold on;
    quiver([1:size(im,2)], [1:size(im,1)], Fext.x, Fext.y, 'r', 'LineWidth', 2);
%     title('Fext');
end
% axis([214,218, 40, 44])
% exportgraphics(gcf, "resultEext/Eline.jpg", "BackgroundColor", [0 0 0]);
% axis([210,222, 36, 48])
% exportgraphics(gcf, "resultEext/Eedge.jpg", "BackgroundColor", [0 0 0]);
% axis([214,218, 40, 44])
% exportgraphics(gcf, "resultEext/Eterm.jpg", "BackgroundColor", [0 0 0]);
% saveas(gcf, "test.jpg");


% step 5: 更新輪廓
if para.displayContour
    h_process = figure(); imshow(im); hold on;
%     h = []; % 提前宣告輪廓的handle
    h = plot(P.Contour(:,1),P.Contour(:,2),'r.','Color',[0 1 0]);   % 繪製初始輪廓
    figure(h_process);  plot([P.Contour(:,1);P.Contour(1,1)],[P.Contour(:,2);P.Contour(1,2)],'-');  drawnow
%     exportgraphics(h_process, ['resultContour\beta_1000\', num2str(0, "%03d"), '.jpg']);
end
for n = 1:para.Iteration
	P.Contour = UpdateContour(P.Contour, B, Fext, para.gamma, para.im_row, para.im_col);
    
%     figure(2);
%     quiver(P.Contour(:,2), P.Contour(:,1), Fint(:,2), Fint(:,1));
    % 顯示當前輪廓
    if para.displayContour
        % 刪除輪廓
        delete(h);
        % 繪製輪廓
        figure(h_process);
        imshow(im);
        h = plot(P.Contour(:,1),P.Contour(:,2),'r.');
        c=n/para.Iteration;
        figure(h_process);
        plot([P.Contour(:,1);P.Contour(1,1)],[P.Contour(:,2);P.Contour(1,2)],'-','Color',[c 1-c 0]);  drawnow
        title("Iteration: " + string(n));
    end
end
h_result = figure(); imshow(im); hold on;
h = plot(P.Contour(:,1),P.Contour(:,2),'r.', 'MarkerSize', 10);
title('result');