pkg load report;

main;

if (!isfolder("results"))
	mkdir("results");
endif

f = fopen("results/summary.tsv", "w");
hdr = {"p[Pa]", "I[mA]", "D_log", "n_log[m-3]",...
	"a_inv", "n_inv[m-3]", "D", "a", "n0[m-3]"};
hdr = strjoin(hdr, "\t");
fputs(f, hdr);
fputs(f, "\n");
invfit = [[[X.invfit].a]' [[X.invfit].n]'];
logfit = [[[X.logfit].DoL]'./L^2 [[X.logfit].n]'];
dlmwrite(f, [p [X.I]' logfit invfit D a n0], "\t");
fclose(f);
