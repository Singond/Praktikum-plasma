main;

function plot_experiment(x)
	plotyy(x.tU, x.U, x.tI, x.I);
endfunction

close all;
for x = X
	figure();
	plot_experiment(x);
endfor
