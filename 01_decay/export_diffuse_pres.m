pkg load report;

main;

gp = gnuplotter;
gp.load("../plotsettings.gp");
gp.plot(p, D, "w p");
gp.exec("\
	set xlabel 'tlak $\\pres\\,[\\si{\\pascal}]$' \n\
	set ylabel '$\\diffuse\\,[\\si{\\diffuseunit}]$' \n\
	set xtics 100 \n\
	set key off \n\
");
gp.export("plots/diffuse-pres.tex", "epslatex", "size 8cm,6cm");
