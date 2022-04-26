pkg load report;

main;

gp = gnuplotter;
gp.load("../plotsettings.gp");
for k = 1:numel(X)
	x = X(k);
	gp.plot(x.tr, x.fr,
		sprintf("w p ls %d t '\\SI{%g}{\\pascal}'", k, x.p));
endfor
gp.xlabel('čas $\\tm\\,[\\si{\\micro\\second}]$');
gp.exec("set key top right samplen 2 spacing 1.5 at graph 0.95,0.90");
gp.ylabel('rezonanční frekvence $\\freq\\,[\\si{\\hertz}]$');
gp.export("plots/freq.tex", "epslatex", "size 17cm,12cm");
