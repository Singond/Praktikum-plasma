pkg load report;

probesimple2;
k = 1;
x = X(k);
s = S(k);

gp = gnuplotter();
gp.load("../plotsettings.gp");
gp.plot(s.all.timelinearized, s.all.val, "w l lc 'black' t 'naměřená data'");
gp.plot(s.all.timelinearized, s.sep, "w l lc 'black' dt 2 t 'rozhodovací funkce'");
gp.plot(s.upper.timelinearized, s.upper.val, "w p ls 1 t 'se střídavým napětím'");
gp.plot(s.lower.timelinearized, s.lower.val, "w p ls 2 t 'bez střídavého napětí'");
gp.xlabel('čas $\\tim\\,[\\si{\\second}]$');
gp.ylabel('sondový proud $\\iprobe\\,[\\si{\\micro\\ampere}]$');
gp.exec("\
	set xrange [185:225] \n\
	set xtics 10 \n\
	set yrange [10:20] \n\
	set ytics 2 \n\
	set key top left reverse Left samplen 2 \n\
");
gp.export(sprintf("plots/separation.tex", k),
	"epslatex", "size 12cm,8cm");
