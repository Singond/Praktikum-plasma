function x = plasmaprops_eedf(x, x_alt, varargin)
	x = plasmaprops_simple(x);
	xa = plasmaprops_simple(x_alt);
	x.Ies2 = xa.Ies;

	## Determine electron energy distribution function
	## using derivative calculated from current increase with
	## alternating voltage added.
	global probesurf Ua;
	x.Ua = Ua;
	x.didu2a = 4 * (x.Ies2 - x.Ies) ./ x.Ua.^2;
	uu = x.Us(x.Us < 0);
	[x.eedfa, x.eedfa_E] = eedfd(uu, x.didu2a(x.Us < 0), probesurf);

	## Fit EEDF calculated from alternating voltage.
	x.fita = fit_eedf(x, "eedfa");
endfunction
