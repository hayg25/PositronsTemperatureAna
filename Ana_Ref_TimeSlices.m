function[Corr_data,timeFull,chanFull,chanRef,delta_temp,raw_max_jump] =  Ana_Ref_TimeSlices(refData,chanData,Time,min1,max1,corr_temp,butter_cut)
close all


%% try to combine the analysis into a single file
%% keep on looping over sensors -----------------
%% Supepose plots

col=colorcube(70);

Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
%% combine data :
[timeFull,chanFull] =  CombineTempData(chanData,Time);
[timeFull,chanRef]  =  CombineTempData(refData,Time);

size(chanFull)

subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.02 0.01], [0.04 0.02 0.01], [0.04 0.02 0.01]);
I_Axis_limits=[-0.2,0.3];
%I_Axis_limits=[0.2,0.7];
I_Axis_limits=[1,5];
%I_Axis_limits=[20,25];

 Nbins_sec=6000;
% Nbins_sec=2000;
 time_shift=558.3;
 %time_shift=1.73;
 time_shift=5280;
 %time_shift=0;
 
 
Nsensor=9 
plo_id=[9,5,1,3,7]
plo_id=[1:9]
% for i=1:9
for i=1:Nsensor
    j=plo_id(i);
    %% --- FFT -----------------
    signal_fft=fft(chanFull(1,:,j));
    %% Low pass filter
    [b,a]=butter(8,[butter_cut]/(1000),'low');
    lowPassedData = filter(b,a,chanFull(1,:,j));
    Corr_data(i,:,:)=lowPassedData(:,:);
    figure(115)
    hold on

    min_temp(i)=min(15*lowPassedData(1,min1:max1)-corr_temp(i));
    max_temp(i)=max(15*lowPassedData(1,min1:max1)-corr_temp(i));
    delta_temp(i)= max_temp(i)-min_temp(i);
    
    plot(timeFull(:,min1:max1)-time_shift,15*lowPassedData(1,min1:max1)-corr_temp(j),'linewidth',2,'color',col(5*i-1,:));
 
%    for ibin=1:floor((max1-min1)/Nbins_sec)+1
%       max_jump(i,ibin)=15*max(lowPassedData(1,min1+(ibin-1)*Nbins_sec:min1+(ibin)*Nbins_sec))-corr_temp(i);
%       raw_max_jump(i,ibin)=15*max(lowPassedData(1,min1+(ibin-1)*Nbins_sec:min1+(ibin)*Nbins_sec))-15*min(lowPassedData(1,min1+(ibin-1)*Nbins_sec:min1+(ibin)*Nbins_sec));
%    end
    
 %   ylim(I_Axis_limits);
    set(gca,'FontSize',20)
    set(gcf, 'color', 'w');
    xlhand = get(gca,'xlabel');
    set(xlhand,'string','Time [sec]','fontsize',20);  
    ylhand = get(gca,'ylabel');
    set(ylhand,'string','Temp [°C]','fontsize',20);  
    legendInfo{i} = ['Sensor No ' num2str(j)];
end
% for i=1:floor((max1-min1)/Nbins_sec)+1
%     bin_droite=min1+(i-1)*Nbins_sec  ;
%     plot([timeFull(:,bin_droite)- time_shift,timeFull(:,bin_droite)- time_shift],I_Axis_limits,'-')    
% end

%%% Ref data -- 
signal_fft=fft(chanRef(1,:));
%% Low pass filter
[b,a]=butter(8,[butter_cut]/(1000),'low');
lowPassedRefData=filter(b,a,chanRef(1,:));


figure(115)
% plot(timeFull(:,min1:max1),15*lowPassedRefData(1,min1:max1)-corr_temp(10),'linewidth',2,'color',col(5*10-1,:));
% Corr_data(10,:,:)=lowPassedData(:,:);
% legendInfo{10} = ['Sensor No ' num2str(10)];
 legend(legendInfo,'FontSize',18);

figure(222)
hold on
for i=1:Nsensor
    plot(max_jump(i,:),'linewidth',2,'color',col(5*i-1,:))
end
 legend(legendInfo,'FontSize',18);

figure(223)
hold on
for i=1:Nsensor
    plot(raw_max_jump(i,:),'linewidth',2,'color',col(5*i-1,:))
end
 legend(legendInfo,'FontSize',18);



