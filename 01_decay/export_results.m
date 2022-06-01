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
logfit = [[[X.logfit].D]' [[X.logfit].n]'];
num = "%f";
unc = "%f+-%f";
Dscale = 1e-3;
nscale = 1e15;
ascale = 1e-14;
for x = X
	fprintf(f, "%.0f", x.p);
	fwrite(f, "\t");
	fprintf(f, num, x.I);
	fwrite(f, "\t");
	fprintf(f, unc, x.logfit.D/Dscale, x.logfit.D_ste/Dscale);
	fwrite(f, "\t");
	fprintf(f, unc, x.logfit.n/nscale, x.logfit.n_ste/nscale);
	fwrite(f, "\t");
	fprintf(f, unc, x.invfit.a/ascale, x.invfit.a_ste/ascale);
	fwrite(f, "\t");
	fprintf(f, unc, x.invfit.n/nscale, x.invfit.n_ste/nscale);
	fwrite(f, "\t");
	fprintf(f, unc, x.D/Dscale, x.nlfit.D_ste/Dscale);
	fwrite(f, "\t");
	fprintf(f, unc, x.a/ascale, x.nlfit.a_ste/ascale);
	fwrite(f, "\t");
	fprintf(f, unc, x.n0/nscale, x.n0_ste/nscale);
	fwrite(f, "\n");
endfor
fclose(f);

