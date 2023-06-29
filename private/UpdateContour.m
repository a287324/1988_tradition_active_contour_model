function C = UpdateContour(C, B, Fext, gamma, im_row, im_col)
    Cnew = zeros(size(C));
	% 計算新輪廓
    Cnew(:,1) = B*(C(:,1) + gamma.*interp2(Fext.x, C(:,1), C(:,2)));
    Cnew(:,2) = B*(C(:,2) + gamma.*interp2(Fext.y, C(:,1), C(:,2)));
    % 輪廓更新(調整輪廓點間距,不調整間距,Fint後期會失真)
    C = InterpolateContourPoints2D(Cnew, size(C,1));  % 輪廓點插值
    % 輪廓點的邊界判斷
    C(C(:,1)<1, 1) = 1; C(C(:,1) > im_col, 1) = im_col;
    C(C(:,2)<1, 2) = 1; C(C(:,2) > im_row, 2) = im_row;
end