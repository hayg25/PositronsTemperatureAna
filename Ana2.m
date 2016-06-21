function[timeFull,chanFull] =  Ana2(chanData,Time)
close all 


%% try to combine the analysis into a single file 
%% keep on looping over sensors -----------------

Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
%% combine data : 
[timeFull,chanFull] =  CombineTempData(chanData,Time);
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.02 0.01], [0.04 0.02 0.01], [0.04 0.02 0.01]);
I_Axis_limits=[23,29];
 for i=1:9
    %% --- FFT -----------------
    signal_fft=fft(chanFull(1,:,i));
    %% Low pass filter 
    [b,a]=butter(8,[20]/(1000),'low');
    lowPassedData=filter(b,a,chanFull(1,:,i));

    figure(114)
  %  subplot(5,5,Granular_sensor_positions(i))
    subplot(9,1,i)
    
%    hold on 
    
    plot(timeFull(:,:),15*chanFull(1,:,i));
    ylim(I_Axis_limits);
    title(sprintf('Sensor (%d)',i));
    set(gca,'FontSize',12)
    if i==9
        xlabel(' Time [sec]')
    end
    ylabel('I [mA]')

    figure(115)
   % subplot(5,5,Granular_sensor_positions(i))
    subplot(9,1,i)
    plot(timeFull(:,:),15*lowPassedData);
    ylim(I_Axis_limits);
    title(sprintf('Sensor (%d)',i));
    set(gca,'FontSize',12)
    if i==9
        xlabel(' Time [sec]')
    end
    ylabel('I [mA]')
    
    
    
 end
 
