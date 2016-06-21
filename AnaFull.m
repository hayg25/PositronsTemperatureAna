%% try to combine the analysis into a single file 

%% first analyse the data : 
ana=0;

if ana==1
    [chanI23,chanI23,realTime23,DT23] =  Loop_over_temp_data(23);
end

%% combine data : 
[timeFull,chanFull] =  CombineTempData(chanI24,DT24);

size(timeFull)
size(chanFull)

%% combined data for the first sensor 
dataFull=chanFull(1,:,1);
tFull=timeFull(1,:);

%% plot FFT to see where to find the noise 

signal_fft=fft(dataFull);
figure(101);
semilogy(abs(signal_fft));


%% Low pass filter 
[b,a]=butter(8,[20]/(1000),'low');
lowPassedData=filter(b,a,dataFull);
figure(102);

I_Axis_limits=[1.5*15,2.5*15];  

subplot(2,1,1);
plot(tFull,15*dataFull);
ylim(I_Axis_limits);
subplot(2,1,2);
plot(tFull,15*lowPassedData);
ylim(I_Axis_limits);

