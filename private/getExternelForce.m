function Fext = getExternelForce(im, Wline, Wedge, Wterm)
	Fext = struct;
	im = double(im);
	% Eline
	Eline = im;
	
	% Eedge
%     im2 = imgaussfilt(im, 1);
    [imgradx, imgrady] = gradient(im, 2);
	Eedge = hypot(imgradx, imgrady);
    
	% Eterm
    mx = [-1;1];
    my = [-1 1];
    mxx = [1;-2;1];
    myy = [1 -2 1];
    mxy = [1 -1;-1 1];
    
    im_x = conv2(im, mx, 'same');
    im_y = conv2(im, my, 'same');
    im_xx = conv2(im, mxx, 'same');
    im_yy = conv2(im, myy, 'same');
    im_xy = conv2(im, mxy, 'same');
    
	Eterm = (im_yy.*(im_x.^2) - 2.*im_xy.*im_x.*im_y + im_xx.*(im_y.^2)) ./ ((1+im_x.^2 + im_y.^2).^(1.5) + eps);
    
	% Eext
	Eext = Wline.*Eline + Wedge.*Eedge + Wterm.*Eterm;
    
	% Fext
	[Fext.x, Fext.y] = gradient(Eext);
end