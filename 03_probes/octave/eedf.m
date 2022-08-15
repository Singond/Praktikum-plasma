function f = eedf(u, i, A = 1)
	global electronmass elemcharge
	f = (1/A) .* sqrt(8 .* electronmass .* elemcharge.^-3 .* abs(u(1:end-2)))...
		.* diff(i, 2) ./ diff(u(1:end-1)).^2;
endfunction
