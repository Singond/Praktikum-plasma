pkg load signal;

0;  # Not a function

Id = [50 40 30 50 50 50 50];  ## Discharge current [mA]
p = [50 50 50 20 10 5 100];   ## Pressure [Pa]

function D = load_data(file)
	filelocal = false;
	if (is_valid_file_id(file))
		f = file;
	else
		f = fopen(file, "r");
		filelocal = true;
	endif

	header = fgetl(f);
	if (!strcmp(header, "No\tTime\tDC/AC\tValue\tUnit\tAUTO"))
		if (filelocal)
			fclose(f);
		endif
		error("Unknown file format");
	endif
	[data, pos, msg] = textscan(f, "%f %s %s %s %s %s");
	D.idx = data{1};
	D.timestring = data{2};
	D.timestruct = cellfun(@strptime, D.timestring, {"%H:%M:%S"});
	D.timeraw = arrayfun(@mktime, D.timestruct);
	## The timestamps are rounded off to seconds.
	## Fit a line through them to obtain equidistant time points.
	b = ols(D.timeraw, [D.idx, ones(size(D.idx))]);
	D.timelinearized = b(1) .* D.idx + b(2);
	## The mean difference between the corrected and original time values
	## is a measure of the time bias applied by the linearization.
	## The closer to zero, the better.
	D.timeerror = mean(D.timelinearized - D.timeraw);
	D.dc = strcmp(data{3}, "DC");
	v = strrep(data{4}, ",", ".");
	v = str2double(v);
	v(isnan(v)) = NA;
	D.val = v;
	D.unit = data{5};
	D.pass = strcmp(data{6}, "pass");

	if (filelocal)
		fclose(f);
	endif
endfunction

function [utime, itime] = align(udata, idata)
	starttime = min(udata.timelinearized(1), idata.timelinearized(1));
	utime = udata.timelinearized - starttime;
	itime = idata.timelinearized - starttime;
endfunction

function x = load_experiment(udata, idata)
	x.Utimeerror = udata.timeerror;
	x.Itimeerror = idata.timeerror;
	x.Uunit = udata.unit;
	x.Iunit = idata.unit;
	x.Uraw = udata.val;
	x.Iraw = -idata.val;
	[x.Utime, x.Itime] = align(udata, idata);
endfunction

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

function x = extract_vacx(x, varargin)
	[x.U, x.I] = extract_vac(x.Utime, x.Uraw, x.Itime, x.Iraw, varargin{:});
endfunction

function x = process(x)
	x.Im = mean(x.I, 2);
	x.Ufl = zerocrossing(x.U, x.Im);    # Floating potential
	assert(size(x.Ufl, 1));

	## Extrapolate ion current from the flat initial part.
	z = find(x.Im < 0)(end);
	saturated = (1:round(0.4*z))';
	b = ols(x.Im(saturated), [x.U(saturated) ones(size(find(saturated)))]);
	x.Ii = b(1) * x.U + b(2);
	x.Ie = x.Im - x.Ii;

	## Determine plasma potential Up
	n = numel(x.Ie);
	partb = (round(n/4):round(n/2))';
	partc = (round(3*n/4):n)';
	b = ols(log(x.Ie(partb)), [x.U(partb) ones(size(find(partb)))]);
	c = ols(log(x.Ie(partc)), [x.U(partc) ones(size(find(partc)))]);
	x.Up = (c(2) - b(2)) / (b(1) - c(1));

	## Probe voltage wrt plasma
	x.Us = x.U - x.Up;
endfunction

U = struct();
I = struct();
X = struct();
for k = 1:7
	U(k) = load_data(sprintf("data/voltage%02d.txt", k));
	I(k) = load_data(sprintf("data/current%02d.txt", k));
	x = load_experiment(U(k), I(k));
	x.Id = Id(k);
	x.p = p(k);
	X(k) = x;
endfor
clear U I k x;

X(1).U = [];
X(1).I = [];
X(1) = extract_vacx(X(1), [7 276; 288 555], 500);
X(2) = extract_vacx(X(2), [15 282; 288 557], 500);
X(3) = extract_vacx(X(3), [12 281; 288 558], 500);
X(4) = extract_vacx(X(4), [13 281; 291 560], 500);
X(5) = extract_vacx(X(5), [10 281; 315 583], 500);
X(6) = extract_vacx(X(6), [12 282; 288 556], 500);
X(7) = extract_vacx(X(7), [291 559], 500);

X = arrayfun(@(x) process(x), X);
