## -*- texinfo -*-
## @deftypefn  {} {[@var{D1}, @var{D2}] =} @
##     separate_data (@var{D}, @var{n}, @var{k})
## @deftypefnx {} {[@dots{}, @var{sep}, @var{ulim}, @var{llim}] =} @
##     separate_data (@dots{})
##
## Separate signal into two series by selecting points above and below
## a certain threshold value.
## The threshold value is the signal smoothed by a window of length
## @var{n} points, optionally widened by a @var{k}-multiple of the
## standard deviation of the signal from the smoothed data.
##@end deftypefn
function [D1, D2, y, yu, yl] = separate_data(D, n, k = 0)
	y = movmean(D.val, n);
	d = D.val - y;
	ddev = sqrt(sumsq(d) / (numel(d) - 1));
	u = d > k*ddev;
	l = d < -k*ddev;
	D1 = D2 = D;
	D1.timelinearized = D.timelinearized(u);
	D1.val = D.val(u);
	D2.timelinearized = D.timelinearized(l);
	D2.val = D.val(l);
	if (isargout(4))
		yu = y + k*ddev;
	endif
	if (isargout(5))
		yl = y - k*ddev;
	endif
endfunction

