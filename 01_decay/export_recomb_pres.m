pkg load report;

main;

gp = gnuplotter;
gp.load("../plotsettings.gp");
gp.plot(p, a*1e14, "w p");
gp.exec("\
	set xlabel 'tlak $\\pres\\,[\\si{\\pascal}]$' \n\
	set ylabel '$\\recomb\\,[\\SI{e-14}{\\recombunit}]$' \n\
	set xtics 100 \n\
	set key off \n\
");
gp.export("plots/recomb-pres.tex", "epslatex", "size 8cm,6cm");
