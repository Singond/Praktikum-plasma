## -*- texinfo -*-
## @deftypefn  {} {@var{f} =} eedf (@var{u}, @var{didu2})
## @deftypefnx {} {@var{f} =} eedf (@dots{}, @var{a})
##
## Calculate electron energy distribution function from voltage @var{u}
## and @var{didu2}, which is the second derivative of current with respect
## to voltage @var{u}.
##
## Probe surface area can be given as the argument @var{a}.
## The default value is 1.
## @end deftypefn
function f = eedfd(u, didu2, A = 1)
	global electronmass elemcharge
	f = (1/A) .* sqrt(8 .* electronmass .* elemcharge.^-3 .* abs(u))...
		.* didu2;
	f(f < 0) = nan;
endfunction
