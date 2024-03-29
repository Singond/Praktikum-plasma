function x = plasmaprops_double(x)
	pkg load optim;

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

	## Intersections of tail fits with central fit
	x.ml = (x.fita.beta(2) - x.fitb.beta(2))...
		/ (x.fitb.beta(1) - x.fita.beta(1));
	x.mr = (x.fitc.beta(2) - x.fitb.beta(2))...
		/ (x.fitb.beta(1) - x.fitc.beta(1));

	## Alpha points
	x.al = x.ml / 5;
	x.ar = x.mr / 5;

	## Ion currents
	x.Ip2 = x.fita.f(x.al);
	x.Ip1 = x.fitc.f(x.ar);
	x.Ip = abs(x.Ip1) + abs(x.Ip2);

	## Electron currents
	x.I0 = interp1(x.U, x.Im, 0);
	x.Ie1 = x.Ip1 - x.I0;
	x.Ie2 = x.Ip2 - x.I0;
	x.Ie = abs(x.Ie1) + abs(x.Ie2);

	## Check continuity
	x.Itot = x.Ie - x.Ip;
	assert(x.Itot, 0, 1e-14);

	## Electron temperature from asymptote method
	global elemcharge boltzmann;
	R0 = 1 / x.fitb.beta(1);   # Probe equivalent resistance
	G = x.Ie2 ./ x.Ip;
	x.Tea = -(elemcharge / boltzmann) * (G - G^2) * R0 * x.Ip;

	## Electron density from asymptote method
	global ionmass probesurf;
	x.vea = sqrt(8 * boltzmann * x.Tea / (pi * ionmass));  # Mean electron speed
	S = 8e-3 * 2 * pi * 0.01;    # Surface of boundary layer (guess)
	x.nea = 2 * x.Ip*1e-6 / (S * elemcharge * x.vea);

	## General model
	model = @(U, beta) beta(1) * tanh(beta(2) * U + beta(3))...
			+ beta(4) * U + beta(5);
	beta0 = [x.Ip/2 1 x.U(z) x.fitc.beta(1) 0];
	try
		[Imf, beta, cvg, iter, ~, covp] = leasqr(x.U, x.Im, beta0, model);
		x.fitg.beta = beta;
		x.fitg.I0 = beta(1);
		x.fitg.cvg = cvg;
		x.fitg.iter = iter;
		x.fitg.f = @(U) model(U, beta);
		x.fitg.didu = @(U) beta(1) * beta(2)...
			* (1 - tanh(beta(2) * U + beta(3)).^2) + beta(4);
		## Electron temperature and density from fit
		x.fitg.Te = elemcharge / (boltzmann * beta(2));
		x.fitg.ne = x.fitg.I0*1e-6...
			/ (0.61 * probesurf * sqrt(boltzmann * x.fitg.Te / ionmass));
		x.fitg.ve = sqrt(8 * boltzmann * x.fitg.Te / (pi * ionmass));
		x.fitg.ne2 = 2 * x.Ip*1e-6 / (S * elemcharge * x.fitg.ve);
	catch err
		warning(["Failed to fit general distribution: " err.message]);
	end_try_catch
endfunction
