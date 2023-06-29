function B = getInternalForceMatrix(Nc, alpha, beta, gamma)
	% Penta diagonal matrix, one row:
	b(1) = -beta;
	b(2) = alpha + 4*beta;
	b(3) = -2*alpha - 6 *beta;
	b(4) = b(2);
	b(5) = b(1);

	% Make the penta matrix (for every contour point)
	A = b(1)*circshift(eye(Nc), 2, 2);
	A = A+b(2)*circshift(eye(Nc), 1, 2);
	A = A+b(3)*eye(Nc);
	A = A+b(4)*circshift(eye(Nc),-1, 2);
	A = A+b(5)*circshift(eye(Nc),-2, 2);

	% Calculate the inverse
	B = inv(eye(Nc)-gamma.*A);
%     B = inv(gamma.*eye(Nc)-A);
end