% function[Corr_data,timeFull,chanFull,chanRef,delta_temp,raw_max_jump,a,t0,tau1,tau2] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,min2)
function[lowPassedData] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,min2)
close all
Nsensor=9 


%% try to combine the analysis into a single file
%% keep on looping over sensors -----------------
%% Supepose plots

col=colorcube(70);

Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
%% combine data :
[timeFull,chanFull] =  CombineTempData(chanData,Time);
[timeFull,chanRef]  =  CombineTempData(refData,Time);

size(chanFull)

% subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.02 0.01], [0.04 0.02 0.01], [0.04 0.02 0.01]);
% I_Axis_limits=[-0.2,0.3];
% I_Axis_limits=[0.2,0.7];
% I_Axis_limits=[-2,9];
% I_Axis_limits=[20,30];
I_Axis_limits=[-1,10];

%  Nbins_sec=6000;
 Nbins_sec=12000;
% Nbins_sec=2000;
% time_shift=558.3;
% time_shift=1.73;
% time_shift=5280;


period_beam_in_Bins = Nbins_sec; % 6s for 1 period = [1s ON, 5s OFF]
time_shift=540.3;
 
 
% plo_id=[9,5,1,3,7]
plo_id=[1:9]
% for i=1:9

max_jump=zeros(Nsensor,floor((max1-min2)/Nbins_sec)+1);
raw_max_jump=zeros(Nsensor,floor((max1-min2)/Nbins_sec)+1);

min_temp=zeros(Nsensor);
max_temp=zeros(Nsensor);
delta_temp=zeros(Nsensor);
corr_temp=zeros(Nsensor);

for i=1:Nsensor
    j=plo_id(i);
    %% --- FFT -----------------
    % ----- NOT USED ----    signal_fft=fft(chanFull(1,:,j));
    %% Low pass filter
    [b,a]=butter(8,[butter_cut]/(1000),'low');
    lowPassedData = filter(b,a,chanFull(1,:,j));
    
    Corr_data(i,:,:)=lowPassedData(:,:);
    figure(115)
    hold on
%% --------------- MIN and MAX temp ---- NOT USED YET ------------
    min_temp(i)=min(15*lowPassedData(1,min1:max1));
    max_temp(i)=max(15*lowPassedData(1,min1:max1));
    delta_temp(i)= max_temp(i)-min_temp(i);
%% ---------------------------------------------------------------

    corr_temp(i)=mean(lowPassedData(1,200:400) ); %% ---  ?? pourquoi ? 

%%% --------------------------------------------------------------------------    

   plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1)),'linewidth',2,'color',col(5*i-1,:));
    
   period_time_down = timeFull(:,min1:max1) -  time_shift;
   period_temp_down = 15*( lowPassedData(1,min1:max1));

   options1 = fitoptions('Method','NonlinearLeastSquares') ;
   myfittype1   = fittype('a1*exp(-(x+t1)/tau1)','coefficients',{'a1','t1','tau1'}); %% fit the decrease only
   [myfit1,gof1]   = fit(period_time_down',period_temp_down',myfittype1,options1)
   %% boucle sur le nombre de periodes pour pouvoir effectuer les fits de la forme a.exp(-(t+d+t0)/tau1)*(1-exp(-(t+d+t0)/tau2))




 %   ylim(I_Axis_limits);
    set(gca,'FontSize',20)
    set(gcf, 'color', 'w');
    xlhand = get(gca,'xlabel');
    set(xlhand,'string','Time [sec]','fontsize',20);  
    ylhand = get(gca,'ylabel');
    set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  
    legendInfo{i} = ['Sensor No ' num2str(j)];
end


