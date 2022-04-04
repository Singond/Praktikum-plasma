main;

function plot_experiment(x)
	ax = plotyy(x.tU, x.U, x.tI, x.I);
	xlabel("time t [s]");
	ylabel(ax(1), "voltage U [V]");
	ylabel(ax(2), "current I [uA]");
endfunction

close all;
for x = X
	figure();
	plot_experiment(x);
endfor
