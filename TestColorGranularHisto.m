Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];

figure
hold on
for j=1:100
    for i=1:9
     subplot(5,5,Granular_sensor_positions(i))
     set(gca,'Color',[rand(1) 0.1 0.9]);
    end
    pause(1)
end