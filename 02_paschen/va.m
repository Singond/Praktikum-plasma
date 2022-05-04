d = dlmread("data/va.tsv", [], 4, 0);
va.R = d(:,1);
va.I = d(:,2:end);
va.I(va.I==0) = NA;
