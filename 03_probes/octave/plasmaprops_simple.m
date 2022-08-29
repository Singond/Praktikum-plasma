function x = plasmaprops_simple(x, varargin)
	p = inputParser;
	p.addParameter("polydeg", 8);
	p.parse(varargin{:});
	args = p.Results;

	x.Im = mean(x.I, 2);                # Mean probe current
	x.Ufl = zerocrossing(x.U, x.Im);    # Floating potential
	if (numel(x.Ufl) > 1)
		warning("Multiple roots found in VAC, using their mean.");
		x.Ufl = mean(x.Ufl(:));
	endif
	assert(size(x.Ufl, 1));

	## Extrapolate ion current from the flat initial part.
	z = find(x.Im < 0)(end);
	saturated = (1:round(0.4*z))';
	b = ols(x.Im(saturated), [x.U(saturated) ones(size(find(saturated)))]);
	x.Ii = b(1) * x.U + b(2);           # Ion current
	x.Ie = x.Im - x.Ii;                 # Electron current

	## Smooth Ie by fitting a polynomial
	## Add some constant C to voltage to avoid singular matrix in fit
	C = -mean(x.U([1 end]));
	polydeg = args.polydeg;
	if (isscalar(polydeg))
		polydeg = polydeg:-1:0;
	endif
	uu = (x.U + C) .^ (polydeg);
	b = ols(x.Ie, uu);
	x.Ies = polyval(b, x.U + C);
	clear b;

	## Second derivative of electron current
	x.didu2 = diff(x.Ies, 2) ./ diff(x.U(1:end-1)).^2;

	## Determine plasma potential from the second derivative.
	## This should occur at its zero, but in practice, there is no zero nearby.
	## Instead, take the rightmost local minimum.
	[~, loc] = findpeaksp(-x.didu2);
	if (!isempty(loc))
		x.Upd = x.U(loc(end));
	else
		warning("Cannot find local minimum in d2I/dU2");
		x.Upd = NA;
	endif

	## Determine plasma potential Up using the asymptote method
	n = numel(x.Ie);
	partb = (round(n/4):round(n/2))';
	partc = (round(3*n/4):n)';
	logIe = log(x.Ie);
	b = ols(real(log(x.Ie(partb))), [x.U(partb) ones(size(find(partb)))]);
	c = ols(real(log(x.Ie(partc))), [x.U(partc) ones(size(find(partc)))]);
	x.b = b;
	x.c = c;
	x.bfit = @(U) exp(b(1) .* U + b(2));
	x.cfit = @(U) exp(c(1) .* U + c(2));
	x.Upa = (c(2) - b(2)) / (b(1) - c(1));

	## Choose from the values of plasma potential.
	## Using the value from the second derivative gives better results.
	x.Up = x.Upd;

	## Probe voltage wrt plasma
	x.Us = x.U - x.Up;

	## Electron temperature from asymptote method
	global elemcharge boltzmann;
	x.Tea = elemcharge / (boltzmann * x.b(1));  # Electron temperature

	## Electron temperature from floating potential
	global electronmass ionmass;
	x.Tep = abs(x.Ufl - x.Up) * 2 * elemcharge...
		/ (log(ionmass / (4 * pi * electronmass)) * boltzmann);

	## Choose from the values of electron temperature
	x.Te = mean([x.Tea x.Tep], 2);

	## Electron density
	global probesurf;
	x.ne = x.Ie .* 1e-6 .* sqrt(2 * pi * electronmass / (boltzmann * x.Te))...
		/ (probesurf * elemcharge);

	## Determine electron energy distribution function
	## using numerical derivative
	u = x.Us(x.Us < 0);
	[x.eedfn, x.eedfn_E] = eedf(u, x.Ies(x.Us < 0), probesurf);
endfunction
