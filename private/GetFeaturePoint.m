function P = GetFeaturePoint(im, Nc)
	P = struct;
	% 顯示影像
	figure(1);  imshow(im);
	title('請使用滑鼠決定輪廓點,按Enter結束');
	% 取得使用者設置的輪廓點
    [x,y] = getpts;
	P.Contour = [x(:) y(:)];
    save('parameter\contour_and_object.mat', 'P');
    % 輪廓點插點
	P.Contour = MakeContourClockwise2D(P.Contour);          % 確保輪廓點是順時針
	P.Contour = InterpolateContourPoints2D(P.Contour, Nc);  % 輪廓點插值
    % 畫出插點後的輪廓點
	hold on; plot(P.Contour(:,1),P.Contour(:,2),'b.');
	pause(1); 
    close;
end