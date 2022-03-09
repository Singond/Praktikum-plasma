main;

figure;
hold on;
for k = 1:7
	plot(gca, E(k).tr, E(k).fr, "d");
end
hold off;
