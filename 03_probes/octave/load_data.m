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
