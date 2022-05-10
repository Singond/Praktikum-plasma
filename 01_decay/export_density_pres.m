pkg load report;

main;

nscale = 1e15;
gp = gnuplotter;
gp.load("../plotsettings.gp");
gp.plot(p, n0./nscale, "w p");
gp.exec("\
	set xlabel 'tlak $\\pres\\,[\\si{\\pascal}]$' \n\
	set ylabel '$\\densinit\\,[\\SI{e-15}{\\metre^{-3}}]$' \n\
	set key off \n\
");
gp.export("plots/density-pres.tex", "epslatex", "size 8cm,6cm");