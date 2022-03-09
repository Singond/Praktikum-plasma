0;  # Not a function

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

E(1) = importdata("data/data01.tsv");
E(2) = importdata("data/data02.tsv");
E(3) = importdata("data/data03.tsv");
E(4) = importdata("data/data04.tsv");
E(5) = importdata("data/data05.tsv");
E(6) = importdata("data/data06.tsv");
E(7) = importdata("data/data07.tsv");
