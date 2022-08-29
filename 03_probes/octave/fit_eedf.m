function x = fit_eedf(x)
	pkg load optim;

	if (isstruct(x) && !isscalar(x))
		a = struct();
		for k = 1:numel(x);
			a(k) = arrayfun(@(x) fit_eedf(x), x(k));
		endfor
		x = reshape(a, size(x));
		return
	endif

	E = x.eedfa_E;
	f = x.eedfa;

	if (any(isnan(f)))
		m = E < min(E(isnan(f)));
		E = E(m);
		f = f(m);
	endif
	x.fitE = E;
	x.fitf = f;

	## Fit Maxwell-Boltzmann distribution (linearized)
	## f(E) = a * sqrt(E) * exp(-E/b)
	beta = ols(log(f) - log(E)/2, [ones(size(E)) E]);
	x.mbfit = struct();
	x.mbfit.beta = beta;
	x.mbfit.a = exp(beta(1));
	x.mbfit.b = -1/beta(2);
	x.mbfit.f = @(E) exp(beta(1) + beta(2).*E) .* sqrt(E);

	## Fit Druyvesteyn distribution (linearized)
	## f(E) = a * sqrt(E) * exp((-E/b)^2)
	beta = ols(log(f) - log(E)/2, [ones(size(E)) E.^2]);
	x.drfit = struct();
	x.drfit.beta = beta;
	x.drfit.a = exp(beta(1));
	x.drfit.b = 1/sqrt(abs(beta(2)));  # XXX
	x.drfit.f = @(E) exp(beta(1) + beta(2).*E.^2) .* sqrt(E);

	## Fit general distribution
	## f(E) = a * sqrt(E) * exp((-E/b)^c)
	model = @(E, beta) sqrt(E) .* beta(1) .* exp(-(E./beta(2)).^beta(3));
	beta0 = [x.drfit.a x.drfit.b 2];
	[fm, beta, cvg, iter, ~, covp] = leasqr(E, f, beta0, model);
	x.gfit.beta = beta;
	x.gfit.f = @(E) model(E, beta);
	x.gfit.a = beta(1);
	x.gfit.b = beta(2);
	x.gfit.c = beta(3);
endfunction
