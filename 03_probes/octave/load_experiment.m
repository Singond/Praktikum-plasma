function x = load_experiment(udata, idata)
	x.Utimeerror = udata.timeerror;
	x.Itimeerror = idata.timeerror;
	x.Uunit = udata.unit;
	x.Iunit = idata.unit;
	x.Uraw = udata.val;
	x.Iraw = -idata.val;
	[x.Utime, x.Itime] = align(udata, idata);
endfunction
