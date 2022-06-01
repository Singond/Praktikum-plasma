f = fopen("data/swarm.txt");
fskipl(f, 21);
assert(fgetl(f), " Transport coefficients");
fskipl(f, 17);

finished = false;
data_bolsig = [];
while (!finished)
	## Note that some of the numbers seem to be in bad format
	## (they are missing the E before the exponent).
	## If the whole line is to be read, it might be necessary
	## toc read the file as strings and convert to numbers later.
	line = fgetl(f);
	if (strcmp(line, " "))
		finished = true;
	else
		## Read only to 5th column, which is what we are
		datarow = textscan(line, "%*f %f %f %f %f", 1);
		data_bolsig = [data_bolsig; datarow{:}];
	endif
endwhile
fclose(f);

Er_bolsig = data_bolsig(:,1);
nD_bolsig = data_bolsig(:,4);
