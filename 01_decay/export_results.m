pkg load report;

main;

if (!isfolder("results"))
	mkdir("results");
endif

f = fopen("results/summary.tsv", "w");
fputs(f, "p[Pa] I[mA] D a n0[m-3]\n");
dlmwrite(f, [p [X.I]' D a n0], "\t");
fclose(f);