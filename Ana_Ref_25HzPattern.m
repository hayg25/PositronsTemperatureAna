% function[Corr_data,timeFull,chanFull,chanRef,delta_temp,raw_max_jump,a,t0,tau1,tau2] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,min2)
function[tau1,a2,tau2,rsquare1,rsquare2] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,min2)
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
   plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1) - mean(lowPassedData(1,min1:min1+100))),'linewidth',2,'color',col(5*i-1,:));
    
   %% boucle sur le nombre de periodes pour pouvoir effectuer les fits de la forme a.exp(-(t+d+t0)/tau1)*(1-exp(-(t+d+t0)/tau2))
   for iperiod = 1:(max1-min1)/period_beam_in_Bins
       figure(122+iperiod)
       hold on   
       fprintf('iperiod : %d %d %d  \n',iperiod,max1-min1,period_beam_in_Bins);       
%        plot(timeFull(:,min1+(iperiod-1)*period_beam_in_Bins:min1+(iperiod)*period_beam_in_Bins) - time_shift,15*( lowPassedData(1,min1+(iperiod-1)*period_beam_in_Bins:min1+(iperiod)*period_beam_in_Bins) - mean(lowPassedData(1,min1:min1+100))),'linewidth',2,'color',col(5*i-1,:));
       
%        myfittype = fittype('a*exp(-(x+t0)/tau1)*(1-exp(-(x+t0)/tau2))','coefficients',{'a','t0','tau1','tau2'});
       myfittype1   = fittype('a1*exp(-(x+t1)/tau1)','coefficients',{'a1','t1','tau1'}); %% fit the decrease only
       myfittype2   = fittype('a2*x+tau2' ,'coefficients',{'a2','tau2'}); %% fit the increase only
       
       Lim1        = min2+(iperiod-1)*period_beam_in_Bins + floor(period_beam_in_Bins/6.); %% start from peak position to fit only decrease
       Lim2        = min2+(iperiod)  *period_beam_in_Bins;
       Lim0        = min2+(iperiod-1)*period_beam_in_Bins; 

       temp_shift  = mean(lowPassedData(1,min1:min1+100));
       

       % periode temps et temp partie croissante 
       period_time_up   = timeFull(:,Lim0:Lim1) - time_shift; %% on retire 6 secondes pour etre toujours dans le meme range
       period_time_up   = period_time_up - min(period_time_up);
       period_temp_up   = 15*( lowPassedData(1,Lim0:Lim1) - temp_shift);

       % periode temps et temp partie decroissante 
       period_time_down = timeFull(:,Lim1:Lim2) - time_shift; %% on retire 6 secondes pour etre toujours dans le meme range
       period_time_down = period_time_down - min(period_time_down)+max(period_time_up);
       period_temp_down = 15*( lowPassedData(1,Lim1:Lim2) - temp_shift);

       fprintf('%d %g %g \n', min(period_time_down), max(period_time_down),iperiod);
       

       %        plot(period_time_down,period_temp_down,'linewidth',2,'color',col(5*i-1,:));
       %        options = fitoptions('Method','NonlinearLeastSquares','lower',[-Inf,-Inf,3],'upper',[Inf,Inf,12]) ;
   
       options1 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[4.578,1.154,2.347]) ;
       options2 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[1.676,-0.022]) ;

       [myfit1,gof1]   = fit(period_time_down',period_temp_down',myfittype1,options1)
       if gof1.rsquare > 0.75     
         a1(i,iperiod)       = myfit1.a1;
         t1(i,iperiod)       = myfit1.t1;
         tau1(i,iperiod)     = myfit1.tau1;
         rsquare1(i,iperiod) = gof1.rsquare;
       else 
           fprintf(' Bad fitting --> \n');
           gof1
       end       
       [myfit2,gof2]   = fit(period_time_up',period_temp_up',myfittype2,options2)            
       if gof2.rsquare > 0.75     
         a2(i,iperiod)       = myfit2.a2;
         tau2(i,iperiod)     = myfit2.tau2;
         rsquare2(i,iperiod) = gof2.rsquare;
       else 
           fprintf(' Bad fitting --> \n');
           gof2         
       end       
       
       if gof1.rsquare > 0.75
               pl1 = plot(myfit1 ,period_time_down ,period_temp_down,'--mo')
               set(pl1,'Color',col(5*i-1,:),'LineWidth',2)
        end 
       if gof2.rsquare > 0.75
               pl2 = plot(myfit2 ,period_time_up   ,period_temp_up,'-.r*')
               set(pl2,'Color',col(5*i-1,:),'LineWidth',2)
       end 



       % legend( 'data1','Fit1','data2','Fit2','data3','Fit3')

      set(gca,'FontSize',20)
      set(gcf, 'color', 'w');
      xlhand = get(gca,'xlabel');
      set(xlhand,'string','Time [sec]','fontsize',20);  
      ylhand = get(gca,'ylabel');
      set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  

       
   end
%%% --------------------------------------------------------------------------    
   


%     plot(min1:max1,                       15*( lowPassedData(1,min1:max1) - mean(lowPassedData(1,min1:min1+100))),'linewidth',2,'color',col(5*i-1,:));
%% Calculs dans les intervalles de periode du faisceau (ex : 1s ON, 5s OFF = 6s la periode)    
%% pour les fits il faudra plutot sauver pour chaque intervalle la points dans un tableau qui sera fitt? 
%% ne pas oublier le decalage utilise pour les droites permettant de separer chaque periode
   for ibin=1:floor((max1-min2)/Nbins_sec)+1
      max_jump(i,ibin)     = 15*max(lowPassedData(1,min2+(ibin-1)*Nbins_sec:min2+(ibin)*Nbins_sec))-corr_temp(i);
      raw_max_jump(i,ibin) = 15*max(lowPassedData(1,min2+(ibin-1)*Nbins_sec:min2+(ibin)*Nbins_sec))-15*min(lowPassedData(1,min2+(ibin-1)*Nbins_sec:min2+(ibin)*Nbins_sec));
   end
    
 %   ylim(I_Axis_limits);
    set(gca,'FontSize',20)
    set(gcf, 'color', 'w');
    xlhand = get(gca,'xlabel');
    set(xlhand,'string','Time [sec]','fontsize',20);  
    ylhand = get(gca,'ylabel');
    set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  
    legendInfo{i} = ['Sensor No ' num2str(j)];
end


%%% plot les droites qui separent chaque periode de faisceau
figure(115)
for i=1:floor((max1-min2)/Nbins_sec)+1
    bin_droite=min2+(i-1)*Nbins_sec  ;
    plot([timeFull(:,bin_droite)- time_shift,timeFull(:,bin_droite)- time_shift], I_Axis_limits,'-')    
%   plot([bin_droite,bin_droite]- time_shift                                    , I_Axis_limits,'-')    
end

%%% Ref data -- 
signal_fft=fft(chanRef(1,:));
%% Low pass filter
[b,a]=butter(8,[butter_cut]/(1000),'low');
lowPassedRefData=filter(b,a,chanRef(1,:));


figure(115)
legend(legendInfo,'FontSize',18);
set(gca,'FontSize',20)
set(gcf, 'color', 'w');
xlhand = get(gca,'xlabel');
set(xlhand,'string','Time [sec]','fontsize',20);  
ylhand = get(gca,'ylabel');
set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  
    

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



