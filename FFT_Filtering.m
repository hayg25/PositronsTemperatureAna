function FFT_Filtering(timeFull,chanFull)
close all 

npoints=1000;

np_start=23000;


n_min=300;
n_max=600;


%% combined data for the first sensor 
dataFull=chanFull(1,np_start:np_start+npoints,1);
tFull=timeFull(1,np_start:np_start+npoints);

%% plot FFT to see where to find the noise 

signal_fft=fft(dataFull);
figure(101);
semilogy(abs(signal_fft(1:npoints/2)),'LineWidth',3);


%% test low pass filter limits
figure(102);
I_Axis_limits=[24,26];  
subplot(2,1,1);
title('Raw data');
hold on 
plot(tFull(n_min:n_max),15*dataFull(n_min:n_max));
xlabel(' Time [sec]')
ylabel(' Temp [Celcius]')
ylim(I_Axis_limits);
k=0;
for i=5:10
    k=k+1;
    legendInfo{k} = ['Max Cut = ' num2str(i*10)];
    %% Low pass filter 
    [b,a]=butter(8,[10*i]/(npoints),'low');
    lowPassedData=filter(b,a,dataFull);
    subplot(2,1,2);
    title('(low pass) Filtered data');

    hold on
    plot(tFull(n_min:n_max),15*lowPassedData(n_min:n_max),'LineWidth',3);
    ylim(I_Axis_limits);
    xlabel(' Time [sec]')
    ylabel(' Temp [Celcius]')
    
    
end 
legendInfo
legend(legendInfo);