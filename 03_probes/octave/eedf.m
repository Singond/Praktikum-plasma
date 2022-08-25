## -*- texinfo -*-
## @deftypefn  {} {@var{f} =} eedf (@var{u}, @var{i})
## @deftypefnx {} {@var{f} =} eedf (@dots{}, @var{a})
## @deftypefnx {} {@var{f}, @var{u} =} eedf (@dots{})
##
## Calculate electron energy distribution function from voltage @var{u}
## and current @var{i}.
##
## Probe surface area can be given as the argument @var{a}.
## The default value is 1.
##
## The optional return value @var{u} are the values of voltage
## corresponding to @var{f}.
## @end deftypefn
function [f, uu] = eedf(u, i, A = 1)
	uu = u(1:end-2);
	f = eedfd(uu, diff(i, 2) ./ diff(u(1:end-1)).^2, A);
endfunction
