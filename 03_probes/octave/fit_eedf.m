function r = fit_eedf(x, df)
	pkg load optim;
	pkg load singon-ext;

	if (isstruct(x) && !isscalar(x))
		a = struct();
		for k = 1:numel(x);
			a(k) = arrayfun(@(x) fit_eedf(x, df), x(k));
		endfor
		r = reshape(a, size(x));
		return
	endif

	if (strcmp(df, "eedfa"))
		E = x.eedfa_E;
		f = x.eedfa;
	elseif (strcmp(df, "eedfn"))
		E = x.eedfn_E;
		f = x.eedfn;
	else
		error("DF must be either 'eedfa' or 'eedfn'");
	endif

	## Take only values up to first NaN or local minimum
	Emax = max(E);
	if (any(isnan(f)))
		Emax = min(E(isnan(f)));
	endif
	[~, loc] = findpeaksp(-f);
	minima = E(loc);
	if (!isempty(minima))
		Emax = min(Emax, min(minima));
	endif
	m = E < Emax;
	E = E(m);
	f = f(m);
	r.E = E;
	r.f = f;

	global elemcharge boltzmann;

	## Fit Maxwell-Boltzmann distribution (linearized)
	## f(E) = a * sqrt(E) * exp(-E/b)
	beta = ols(log(f) - log(E)/2, [ones(size(E)) E]);
	r.mb = struct();
	r.mb.beta = beta;
	r.mb.a = exp(beta(1));
	r.mb.b = -1/beta(2);
	r.mb.f = @(E) exp(beta(1) + beta(2).*E) .* sqrt(E);
	r.mb.T = r.mb.b * elemcharge / boltzmann;

	## Fit Maxwell-Boltzmann distribution non-linearly
	## f(E) = a * sqrt(E) * exp(-E/b)
	model = @(E, beta) sqrt(E) .* beta(1) .* exp(-E./beta(2));
	beta0 = [r.mb.a 10000 * boltzmann / elemcharge];
	try
		[fm, beta, cvg, iter, ~, covp] = leasqr(E, f, beta0, model);
		r.mbnl.beta = beta;
		r.mbnl.f = @(E) model(E, beta);
		r.mbnl.a = beta(1);
		r.mbnl.b = beta(2);
		r.mbnl.T = r.mbnl.b * elemcharge / boltzmann;
		if (!cvg)
			warning("Maxwell-Boltzmann fit did not converge");
		elseif (iter == 1)
			warning("Maxwell-Boltzmann fit stopped after first iteration");
		endif
	catch err
		warning(["Failed to fit Maxwell-Boltzmann distribution: " err.message]);
	end_try_catch

	## Fit Druyvesteyn distribution (linearized)
	## f(E) = a * sqrt(E) * exp((-E/b)^2)
	beta = ols(log(f) - log(E)/2, [ones(size(E)) E.^2]);
	r.dr = struct();
	r.dr.beta = beta;
	r.dr.a = exp(beta(1));
	r.dr.b = 1/sqrt(abs(beta(2)));  # XXX
	r.dr.f = @(E) exp(beta(1) + beta(2).*E.^2) .* sqrt(E);
	r.dr.T = r.dr.b * elemcharge / boltzmann;

	## Fit Druyvesteyn distribution non-linearly
	## f(E) = a * sqrt(E) * exp((-E/b)^2)
	model = @(E, beta) sqrt(E) .* beta(1) .* exp(-(E./beta(2)).^2);
	beta0 = [r.mb.a 10000 * boltzmann / elemcharge];
	try
		[fm, beta, cvg, iter, ~, covp] = leasqr(E, f, beta0, model);
		r.drnl.beta = beta;
		r.drnl.f = @(E) model(E, beta);
		r.drnl.a = beta(1);
		r.drnl.b = beta(2);
		r.drnl.T = r.drnl.b * elemcharge / boltzmann;
		if (!cvg)
			warning("Druyvesteyn fit did not converge");
		elseif (iter == 1)
			warning("Druyvesteyn fit stopped after first iteration");
		endif
	catch err
		warning(["Failed to fit Druyvesteyn distribution: " err.message]);
	end_try_catch

	## Fit general distribution
	## f(E) = a * sqrt(E) * exp((-E/b)^c)
	model = @(E, beta) sqrt(E) .* beta(1) .* exp(-(E./beta(2)).^beta(3));
	beta0 = [r.dr.a r.dr.b 2];
	try
		[fm, beta, cvg, iter, ~, covp] = leasqr(E, f, beta0, model);
		r.gen.beta = beta;
		r.gen.f = @(E) model(E, beta);
		r.gen.a = beta(1);
		r.gen.b = beta(2);
		r.gen.c = beta(3);
		r.gen.T = r.gen.b * elemcharge / boltzmann;
		r.kappa = r.gen.c;
		if (!cvg)
			warning("General fit did not converge");
		elseif (iter == 1)
			warning("General fit stopped after first iteration");
		endif
	catch err
		warning(["Failed to fit general distribution: " err.message]);
	end_try_catch
endfunction
