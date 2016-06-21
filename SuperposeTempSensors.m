function[timeFull,chanFull] =  SuperposeTempSensors(Data,Time)


[timeFull,chanFull]=CombineTempData(Data,Time);

%% Plot the Temperature for granular target

figure(33)
hold on
I_Axis_limits=[1.3,4];  
V_Axis_limits=[100,120];  
 
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02 0.01], [0.02 0.02 0.01], [0.02 0.02 0.01]);

 
%-----------------------------------------------


% subplot(5,5,25)
% plot(realTimeMT(1:N_pulse_1s),chanI_Environment(1:N_pulse_1s));
% ylim(I_Axis_limits)
% set(gca,'FontSize',14)
% hold off
% xlabel(' Time [sec]')
% ylabel('I [mA]')

