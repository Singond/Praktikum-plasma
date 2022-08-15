function [utime, itime] = align(udata, idata)
	starttime = min(udata.timelinearized(1), idata.timelinearized(1));
	utime = udata.timelinearized - starttime;
	itime = idata.timelinearized - starttime;
endfunction
