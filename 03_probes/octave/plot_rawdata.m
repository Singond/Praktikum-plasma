function plot_rawdata(x)
	ax = plotyy(x.Utime, x.Uraw, x.Itime, x.Iraw);
	xlabel("time t [s]");
	ylabel(ax(1), "voltage U [V]");
	ylabel(ax(2), "current I [uA]");
endfunction
