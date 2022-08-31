function x = plasmaprops_double(x)
	x.Im = mean(x.I, 2);                # Mean probe current
endfunction
