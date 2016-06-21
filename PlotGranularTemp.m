function[timeFull,chanFull] =  PlotGranularTemp(Data,Time)

size(Data)
size(Time)

chanFull = zeros(0,0);
timeFull = zeros(0,0);
% plot(DT23(12,:),chanI23(12,:,1));

Taille=size(Data);
for i=1:Taille(1)
    chanFull = horzcat(chanFull,Data(i,:,:));
    timeFull = horzcat(timeFull,Time(i,:));
end

size(chanFull)
size(timeFull)
%% Plot the Temperature for granular target

figure(33)
I_Axis_limits=[1.3,2];  
V_Axis_limits=[100,120];  
 
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02 0.01], [0.02 0.02 0.01], [0.02 0.02 0.01]);

 
%-----------------------------------------------
 Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
 for i=1:9
%     subplot(5,5,Granular_sensor_positions(i))
    subplot(9,1,i)
    plot(timeFull(:,:),chanFull(1,:,i));
    ylim(I_Axis_limits);
    title(sprintf('Sensor (%d)',i));
    set(gca,'FontSize',12)
    hold off
    if i==8
        xlabel(' Time [sec]')
    end
    if i==9
        ylabel('I [mA]')
    end
 end
 
% subplot(5,5,25)
% plot(realTimeMT(1:N_pulse_1s),chanI_Environment(1:N_pulse_1s));
% ylim(I_Axis_limits)
% set(gca,'FontSize',14)
% hold off
% xlabel(' Time [sec]')
% ylabel('I [mA]')

