function[timeFull,chanFull,chanRef] =  Ana_Corr_WithRef(refData,chanData,Time,corr_temp)
close all


%% try to combine the analysis into a single file
%% keep on looping over sensors -----------------
%% Supepose plots

col=colorcube(70);

Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
%% combine data :
[timeFull,chanFull] =  CombineTempData(chanData,Time);
[timeFull,chanRef] =  CombineTempData(refData,Time);

subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.02 0.01], [0.04 0.02 0.01], [0.04 0.02 0.01]);
I_Axis_limits=[-2,8];

for i=1:9
    %% --- FFT -----------------
    signal_fft=fft(chanFull(1,:,i));
    %% Low pass filter
    [b,a]=butter(8,[15]/(1000),'low');
    lowPassedData=filter(b,a,chanFull(1,:,i));

    figure(114)
    hold on

    plot(timeFull(:,:),15*chanFull(1,:,i)-corr_temp(i),'linewidth',2,'color',col(5*i-1,:));
    

    ylim(I_Axis_limits);
%    title(sprintf('Sensor (%d)',i));
    set(gca,'FontSize',12)
    xlabel(' Time [sec]')
    ylabel('I [mA]')
    xlhand = get(gca,'xlabel');
    set(xlhand,'string','X','fontsize',18);  
    ylhand = get(gca,'ylabel');
    set(ylhand,'string','Y','fontsize',18);  

    
    figure(115)
    hold on

    plot(timeFull(:,:),15*lowPassedData-corr_temp(i),'linewidth',2,'color',col(5*i-1,:));
    ylim(I_Axis_limits);
%    title(sprintf('Sensor (%d)',i));
    set(gca,'FontSize',12)
    xlhand = get(gca,'xlabel');
    set(xlhand,'string','Time [sec]','fontsize',18);  
    ylhand = get(gca,'ylabel');
    set(ylhand,'string','Temp [°C]','fontsize',18);  
    legendInfo{i} = ['Sensor No ' num2str(i)];
end

 


%%% Ref data -- 
signal_fft=fft(chanRef(1,:));
%% Low pass filter
[b,a]=butter(8,[15]/(1000),'low');
lowPassedRefData=filter(b,a,chanRef(1,:));
figure(114)
plot(timeFull(:,:),15*chanRef(1,:)-corr_temp(10),'linewidth',2,'color',col(5*10-1,:));
figure(115)

plot(timeFull(:,:),15*lowPassedRefData-corr_temp(10),'linewidth',2,'color',col(5*10-1,:));


legendInfo{10} = ['Sensor No ' num2str(10)];



figure(114)
legend(legendInfo,'FontSize',14);

figure(115)
legend(legendInfo,'FontSize',14);