probesimple1;
X1 = X;
probesimple2;
X2 = X;
probedouble;

A = zeros(0, 9);

r = 0;
for x = X1
	r += 1;
	A(r,1) = x.p;
	A(r,2) = x.Id;
	A(r,3) = x.Ufl;
	A(r,4) = x.Upa;
	A(r,5) = x.Upd;
	A(r,6) = x.Tea;
	A(r,7) = x.Tep;
endfor

for x = X2
	r += 1;
	A(r,1) = x.p;
	A(r,2) = x.Id;
	A(r,3) = x.Ufl;
	A(r,4) = x.Upa;
	A(r,5) = x.Upd;
	A(r,6) = x.Tea;
	A(r,7) = x.Tep;
	if (isfield(x.fita, "gen"))
		A(r,8) = x.fita.gen.T;
	endif
	A(r,9) = x.fita.kappa;
endfor

if (!isfolder("results"))
	mkdir("results");
endif
f = fopen("results/comparison.tsv", "w");
fwrite(f, "p	Id	Vfl	Vpa	Vpd	Tea	Tep	Tef	kappa\n");
dlmwrite(f, A, "\t");
fclose(f);

A = zeros(0,7);
r = 0;
for x = D
	r += 1;
	A(r,1) = x.p;
	A(r,2) = x.Id;
	A(r,3) = x.Tea;
	A(r,4) = x.fitg.Te;
	A(r,5) = x.nea;
	A(r,6) = x.fitg.ne;
	A(r,7) = x.fitg.ne2;
endfor

f = fopen("results/comparison-double.tsv", "w");
fwrite(f, "p	Id	Tea	Tef	nea	nef	nef2\n");
dlmwrite(f, A, "\t");
fclose(f);
