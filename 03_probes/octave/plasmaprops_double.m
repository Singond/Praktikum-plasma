function x = plasmaprops_double(x)
	x.Im = mean(x.I, 2);                # Mean probe current

	## Fit parts of the VAC with lines

	N = numel(x.U);
	z = find(x.Im > 0)(1);

	## Left part
	sel = (1:round(0.3*N))';
	beta = ols(x.Im(sel), [x.U(sel) ones(size(sel))]);
	x.fita.beta = beta;
	x.fita.f = @(U) beta(1)*U + beta(2);

	## Central part
	sel = (round(z - 0.05*N):round(z + 0.05*N))';
	beta = ols(x.Im(sel), [x.U(sel) ones(size(sel))]);
	x.fitb.beta = beta;
	x.fitb.f = @(U) beta(1)*U + beta(2);

	## Right part
	sel = (round(0.7*N):N)';
	beta = ols(x.Im(sel), [x.U(sel) ones(size(sel))]);
	x.fitc.beta = beta;
	x.fitc.f = @(U) beta(1)*U + beta(2);
endfunction
