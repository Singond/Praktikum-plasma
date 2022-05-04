d = dlmread("data/paschen-distance.tsv", [], 2, 0);
d(d(:,2)==0, :) = [];
xd.p = 100;  # [Pa]
xd.d = d(:,1);
xd.U = d(:,2);

d = dlmread("data/paschen-pressure.tsv", [], 2, 0);
d(d(:,2)==0, :) = [];
xp.d = 30;  # [mm]
xp.p = d(:,1);
xp.U = d(:,2);
