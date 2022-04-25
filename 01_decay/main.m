pkg load optim;

global rt = 9;              # Tube radius [mm]
global rr = 40;             # Resonator radius [mm]
global me = 9.109E-31;      # Electron mass [kg]
global perm = 8.854E-12;    # Permittivity of free space [SI]
global ec = 1.602E-19;      # Elementary charge [C]

global L = rt*1E-3/2.405;   # Diffusion length of fundamental mode [m]

function D = importdata(file)
	filelocal = false;
	if (is_valid_file_id(file))
		f = file;
	else
		f = fopen(file, "r");
		filelocal = true;
	endif

	D.I = fscanf(f, "# I = %f mA ", 1);  # Current [mA]
	D.p = fscanf(f, "# p = %f Pa ", 1);  # Pressure [Pa]
	data = dlmread(f, "", 1, 0);
	D.tr = data(:,1);                    # Time offset at resonance [us]
	D.fr = data(:,2);                    # Resonance frequency [MHz]
	D.f0 = data(1,3);
	D.tr(D.fr < D.f0) = [];
	D.fr(D.fr < D.f0) = [];
	if (filelocal)
		fclose(f);
	endif
endfunction

function n = density(fr, f0)
	global perm me rr rt ec;
	persistent c = 8 * pi^2 * 0.271 / 0.64;
	n = c * perm * me * (rr / rt)^2 .* (fr - f0) .* fr .* 1e12 ./ ec^2;
end

function n = densitymodel(t, DoL, a, c)
	 n = 1 ./ (c .* exp(t.*DoL) - a./DoL);
endfunction

function x = process(file)
	global L;

	x = importdata(file);
	x.df = x.fr - x.f0;
	x.n = density(x.fr, x.f0);

	## Fit 1/n with a line to determine a (coeff. of recombination)
	v = (1:numel(x.n)/2)';
	b = ols(1./x.n(v), [x.tr(v), ones(size(v))]);
	x.invfit.a = b(1);
	x.invfit.n = 1/b(2);

	## Fit log(n) with a line to determine D (coeff. of recombination)
	## DoL = D / Lambda^2
	v = (8:numel(x.n)-2)';
	b = ols(log(x.n(v)), [x.tr(v), ones(size(v))]);
	x.logfit.DoL = -b(1);
	x.logfit.n = exp(b(2));

	## Fit with 1/(c.exp(tD/L^2) - aL^2/D),
	## using previously found a and D as initial guesses.
	## Scale down the values of n to similar order of magnitude as t,
	## which seems to increase the chances of a successful fit.
	## Afterwards, scale the fitted parameters up again.
	scale = 1e-14;
	b0 = ones(3,1);
	b0(1) = 1e-15 / scale;
	b0(2) = x.invfit.a / (x.logfit.DoL * scale);
	b0(3) = x.logfit.DoL * L^2;
	[ym, b, cvg, iter] = leasqr(x.tr, x.n.*scale, b0,
		@(x,b) 1./(b(1).*exp(x*b(3)) - b(2)), [], 50);
	x.nlfit.c = b(1)*scale;
	x.nlfit.DoL = b(3);
	x.nlfit.a = b(2)*b(3)*scale;
end

X = struct();
X(2) = process("data/data01.tsv");
X(1) = process("data/data02.tsv");
X(3) = process("data/data03.tsv");
X(4) = process("data/data04.tsv");
X(5) = process("data/data05.tsv");
X(6) = process("data/data06.tsv");
X(7) = process("data/data07.tsv");
