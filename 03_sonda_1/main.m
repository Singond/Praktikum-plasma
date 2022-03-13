0;  # Not a function

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
	[data, pos, msg] = textscan(f, "%*d %s %s %s %s %s");
	D.timestring = data{1};
	D.timestruct = cellfun(@strptime, D.timestring, {"%H:%M:%S"});
	D.dc = strcmp(data{2}, "DC");
	v = strrep(data{3}, ",", ".");
	v = str2double(v);
	v(isnan(v)) = NA;
	D.val = v;
	D.unit = data{4};
	D.pass = strcmp(data{5}, "pass");

	if (filelocal)
		fclose(f);
	endif
endfunction

U = struct();
I = struct();
for k = 1:7
	U(k) = load_data(sprintf("data/voltage%02d.txt", k));
	I(k) = load_data(sprintf("data/current%02d.txt", k));
endfor
