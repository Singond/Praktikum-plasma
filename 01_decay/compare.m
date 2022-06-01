load_bolsig;

Er = 10;  # Reduced electric field [Td] (assumption)
nD = interp1(Er_bolsig, nD_bolsig, Er);

D_bolsig = @(n) nD ./ n;

