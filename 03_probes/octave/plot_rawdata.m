function plot_rawdata(x, y)
	if (nargin == 1)
		ax = plotyy(x.Utime, x.Uraw, x.Itime, x.Iraw);
		ylabel(ax(1), "voltage U [V]");
		ylabel(ax(2), "current I [uA]");
	elseif (nargin == 2)
		ax = plotyy(x.timelinearized, x.val, y.timelinearized, y.val);
	endif
	xlabel("time t [s]");
endfunction
