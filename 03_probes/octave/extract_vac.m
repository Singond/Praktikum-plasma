function [uu, ii, tt] = extract_vac(utime, uvals, itime, ivals, tranges, pts)
	assert(columns(tranges), 2);
	uranges = interp1(utime, uvals, tranges);
	umin = max(min(uranges, [], 2));
	umax = min(max(uranges, [], 2));
	uu = linspace(umin, umax, pts)';

	ii = NA(pts, rows(tranges));
	for k = 1:rows(tranges)
		tr = tranges(k,:);
		tmin = min(tr);
		tmax = max(tr);
		sel = utime >= tmin & utime <= tmax;
		## The voltage values have steps (they are not monotonic).
		## Fit a parabola through them to correct this.
		ts = utime(sel);
		us = uvals(sel);
		bb = ols(us, [ts.^2 ts ones(size(ts))]);
		a = bb(1);
		b = bb(2);
		c = bb(3);
		## Calculate time values corresponding to uu.
		## Use trial and error to select the correct root
		## of the quadratic equation.
		t0 = (-b + sqrt(b^2 - 4*a*(c - mean([umin umax])))) / (2*a);
		if (t0 > tmin && t0 < tmax)
			tk = (-b + sqrt(b.^2 - 4*a.*(c - uu))) ./ (2*a);
		else
			tk = (-b - sqrt(b.^2 - 4*a.*(c - uu))) ./ (2*a);
		endif
		iik = interp1(itime, ivals, tk);
		if (any(isnan(iik)))
			warning("extract_vac: Some values of current are invalid (NaN). \
Try changing the range [%g %g].", tr);
		endif
		ii(:,k) = iik;
		tt(:,k) = tk;
		k++;
	endfor
endfunction
