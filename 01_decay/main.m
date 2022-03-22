global rt = 9;              # Tube radius [mm]
global rr = 40;             # Resonator radius [mm]
global me = 9.109E-31;      # Electron mass [kg]
global perm = 8.854E-12;    # Permittivity of free space [SI]
global ec = 1.602E-19;      # Elementary charge [C]

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

	if (filelocal)
		fclose(f);
	endif
endfunction

function n = density(fr, f0)
	global perm me rr rt ec;
	persistent c = 8 * pi^2 * 0.271 / 0.64;
	n = c * perm * me * (rr / rt)^2 .* (fr - f0) .* fr .* 1e12 ./ ec^2;
end

function X = process(file)
	X = importdata(file);
	X.df = X.fr - X.f0;
	X.n = density(X.fr, X.f0);
end

X(1) = process("data/data01.tsv");
X(2) = process("data/data02.tsv");
X(3) = process("data/data03.tsv");
X(4) = process("data/data04.tsv");
X(5) = process("data/data05.tsv");
X(6) = process("data/data06.tsv");
X(7) = process("data/data07.tsv");
