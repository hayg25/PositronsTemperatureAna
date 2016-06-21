function[timeFull,chanFull] =  Ana4(chanData,Time)
close all


%% try to combine the analysis into a single file
%% keep on looping over sensors -----------------
%% Supepose plots

col=colorcube(70);

Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
%% combine data :
[timeFull,chanFull] =  CombineTempData(chanData,Time);
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.02 0.01], [0.04 0.02 0.01], [0.04 0.02 0.01]);
I_Axis_limits=[23,29];


%% ------------- Central Sphere ------------
%% FFT
signal_fft_C=fft(chanFull(1,:,1));
%% Low pass filter
[b,a]=butter(8,[20]/(1000),'low');
lowPassedData_central=15*filter(b,a,chanFull(1,:,1));

%% ----------- Other speres
for i=2:9
    %% --- FFT -----------------
    signal_fft=fft(chanFull(1,:,i));
    %% Low pass filter
    [b,a]=butter(8,[20]/(1000),'low');
    lowPassedData=15*filter(b,a,chanFull(1,:,i));
   

    figure(115)
    hold on

    plot(timeFull(:,:),lowPassedData./lowPassedData_central,'linewidth',2,'color',col(5*i-1,:));
  %  ylim(I_Axis_limits);
    title(sprintf('Sensor (%d)',i));
    set(gca,'FontSize',12)
    xlabel(' Time [sec]')
    ylabel('I [mA]')

    legendInfo{i-1} = ['Sensor No ' num2str(i)];
 end

figure(115)
legend(legendInfo,'FontSize',14);