function x = extract_vacx(x, varargin)
	[x.U, x.I] = extract_vac(x.Utime, x.Uraw, x.Itime, x.Iraw, varargin{:});
endfunction
