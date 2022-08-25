## -*- texinfo -*-
## @deftypefn  {} {@var{f} =} eedf (@var{u}, @var{i})
## @deftypefnx {} {@var{f} =} eedf (@dots{}, @var{a})
##
## Calculate electron energy distribution function from voltage @var{u}
## and current @var{i}.
##
## Probe surface area can be given as the argument @var{a}.
## The default value is 1.
## @end deftypefn
function f = eedf(u, i, A = 1)
	f = eedfd(u(1:end-2), diff(i, 2) ./ diff(u(1:end-1)).^2, A);
endfunction
