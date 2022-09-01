if (!exist("D"))
	probedouble;
endif

fig = 1;
figure(fig++);
clf;
title("Total probe current");
plot_vac(D);

