% function[Corr_data,timeFull,chanFull,chanRef,delta_temp,raw_max_jump,a,t0,tau1,tau2] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,min2)
 function[a1,tau1,a2,tau2,b,rsquare] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,make_fit)
%  function[period_time_down,period_temp_down] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,make_fit)
% function[period_time_down,period_temp_down] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,min2)
close all
Nsensor=9; 


%% try to combine the analysis into a single file
%% keep on looping over sensors -----------------
%% Supepose plots

col=colorcube(70);

Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
%% combine data :
[timeFull,chanFull] =  CombineTempData(chanData,Time);
[timeFull,chanRef]  =  CombineTempData(refData,Time);

% subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.02 0.01], [0.04 0.02 0.01], [0.04 0.02 0.01]);

I_Axis_limits=[-1,10];
I_Axis_limits=[23,50];

%  Nbins_sec=6000;
 Nbins_sec=12000;
% Nbins_sec=2000;
% time_shift=558.3;
% time_shift=1.73;
% time_shift=5280;
% time_shift=1026.5;
% time_shift=3240;
time_shift=4255;

% plo_id=[9,5,1,3,7]
plo_id = [1:9];
% for i=1:9

a1         = zeros(Nsensor);
tau1       = zeros(Nsensor);
a2         = zeros(Nsensor);
tau2       = zeros(Nsensor);
b          = zeros(Nsensor);
rsquare    = zeros(Nsensor);
%    
min_temp   = zeros(Nsensor);
max_temp   = zeros(Nsensor);
delta_temp = zeros(Nsensor);
corr_temp  = zeros(Nsensor);

k=0;
% for i=1:Nsensor
for i=1:Nsensor
    k=k+1;
    j=plo_id(i);
    %% --- FFT -----------------
    % ----- NOT USED ----    signal_fft=fft(chanFull(1,:,j));
    %% Low pass filter
    [b,a]=butter(8,[butter_cut]/(1000),'low');
    lowPassedData = filter(b,a,chanFull(1,:,j));
    
%     Corr_data(i,:,:)=lowPassedData(:,:);
    
    figure(115)
    hold on
%% --------------- MIN and MAX temp ---- NOT USED YET ------------
    min_temp(i)=min(15*lowPassedData(1,min1:max1));
    max_temp(i)=max(15*lowPassedData(1,min1:max1));
    delta_temp(i)= max_temp(i)-min_temp(i);
%% ---------------------------------------------------------------

    corr_temp(i)=mean(lowPassedData(1,200:400) ); %% ---  ?? pourquoi ? 

%%% --------------------------------------------------------------------------    

    max_temp = max(15*( lowPassedData(1,min1:max1)));
    min_temp = min(15*( lowPassedData(1,min1:max1)));
    delta_temp = 27 - max_temp;
    delta_temp_min = 25 - min_temp;
    
    
%     plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1))+delta_temp,'linewidth',2,'color',col(5*i-1,:));
    


    data_plot(i) = plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1)),'--o','linewidth',3,'color',col(5*i-1,:));
%     plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1))+delta_temp_min,'linewidth',2,'color',col(5*i-1,:));
    
    legendInfo{k} = ['Sensor No ' num2str(j)];
    if make_fit == 1
        period_time_down = timeFull(:,min1:max1) -  time_shift;
        period_temp_down = 15*( lowPassedData(1,min1:max1));
%         options1         = fitoptions('Method','NonlinearLeastSquares','StartPoint',[1.5,10.14,0.99,0.03,24]);
%         options1         = fitoptions('Method','NonlinearLeastSquares','StartPoint',[40, 0.003, -18,-0.22]); %% 25Hz continuous partie croissante
        options1         = fitoptions('Method','NonlinearLeastSquares','StartPoint',[15, -0.1, 30,-0.0005]); %% 25Hz continuous partie decroissante
%        options1         = fitoptions('Method','NonlinearLeastSquares');
    
    %  --- > Fit decroissance fin 25Hz pattenrn  
    %   options1         = fitoptions('Method','NonlinearLeastSquares','StartPoint',[2,0.1,-5,-0.003,30]);
    %         ,'Lower',[0.5,1.14,0.39,0.01,14],'Upper',[2.5,15.14,1.99,0.5,44]) ;
        myfittype1       = fittype('a1*exp(tau1*x)+a2*exp(tau2*x)','coefficients',{'a1','tau1','a2','tau2'}); %% fit the decrease only
    %   myfittype1       = fittype('a1*exp(-(x*tau1)+t1)','coefficients',{'a1','t1','tau1'}); %% fit the decrease only


        [myfit1,gof1]    = fit(period_time_down',period_temp_down',myfittype1,options1)
    

        a1(i)       = myfit1.a1;
        tau1(i)     = myfit1.tau1;
        a2(i)       = myfit1.a2;
        tau2(i)     = myfit1.tau2;
%         b(i)        = myfit1.b;
        rsquare(i)  = gof1.rsquare;
%    
       pl1 = plot(myfit1);
       set(pl1,'Color','r','LineWidth',2)
       xlim([min(period_time_down)*0.95,max(period_time_down)*1.05]);
%        legendInfo{k} = ['FIT : Sensor No ' num2str(j)];
    
    end
   
    ylim(I_Axis_limits);
    set(gca,'FontSize',20)
    set(gcf, 'color', 'w');
    xlhand = get(gca,'xlabel');
    set(xlhand,'string','Time [sec]','fontsize',20);  
    ylhand = get(gca,'ylabel');
    set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  
end
legend(data_plot,legendInfo,'FontSize',18);


