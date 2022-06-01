pkg load report;

main;
compare;

pp = 1:500;
nn = pp / (kb * temp);
gp = gnuplotter;
gp.load("../plotsettings.gp");
gp.plot(p, D./1e-3, "w p ls 1 t 'experiment'");
##gp.plot(pp, D_bolsig(nn)./1e-3, "w l ls 1 dt 2 t 'Biagi'");
gp.exec("\
	set xlabel 'tlak $\\pres\\,[\\si{\\pascal}]$' \n\
	set ylabel '$\\diffuse\\,[\\SI{e-3}{\\diffuseunit}]$' \n\
	set xtics 100 \n\
	set yrange [0:35] \n\
	set key off \n\
");
gp.export("plots/diffuse-pres.tex", "epslatex", "size 8cm,6cm");
clear pp gp
