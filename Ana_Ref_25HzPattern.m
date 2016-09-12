% function[Corr_data,timeFull,chanFull,chanRef,delta_temp,raw_max_jump,a,t0,tau1,tau2] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,min2,make_fit)
function[max_temp_period,norm_max_temp] =  Ana_Ref_25HzPattern(refData,chanData,Time,min1,max1,butter_cut,min2,make_fit)
close all
Nsensor=9; 
Nperiod = 80;

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
I_Axis_limits=[24,32];

  Nbins_sec=6000;
%  Nbins_sec=12000;
% Nbins_sec=2000;
% time_shift=558.3;
% time_shift=1.73;
% time_shift=5280;


period_beam_in_Bins = Nbins_sec; % 6s for 1 period = [1s ON, 5s OFF]
time_shift=240.3;
 
 
% plo_id=[9,5,1,3,7]
plo_id=[1:9]
% for i=1:9


fprintf(' ---> N periods --> : %d \n ',floor((max1-min2)/Nbins_sec)+1);



max_jump      = zeros(Nsensor,floor((max1-min2)/Nbins_sec)+1);
raw_max_jump  = zeros(Nsensor,floor((max1-min2)/Nbins_sec)+1);

max_temp_period = zeros(Nsensor,Nperiod);
norm_max_temp   = zeros(Nsensor,Nperiod);

min_temp=zeros(Nsensor);
max_temp=zeros(Nsensor);
delta_temp=zeros(Nsensor);
corr_temp=zeros(Nsensor);



figure(122)

max_period = 28; 
min_period = 23; 


figure(115)    
hold on

k=0
for i=1:Nsensor
    j=plo_id(i);
    k = k+1;
    %% --- FFT -----------------
    % ----- NOT USED ----    signal_fft=fft(chanFull(1,:,j));
    %% Low pass filter
    [b,a]=butter(8,[butter_cut]/(1000),'low');
    lowPassedData = filter(b,a,chanFull(1,:,j));
        
%% --------------- MIN and MAX temp ---- NOT USED YET ------------
    min_temp(i)=min(15*lowPassedData(1,min1:max1));
    max_temp(i)=max(15*lowPassedData(1,min1:max1));
    delta_temp(i)= max_temp(i)-min_temp(i);
%% ---------------------------------------------------------------

    corr_temp(i)=mean(lowPassedData(1,200:400) ); %% ---  ?? pourquoi ? 
    legendInfo{k} = ['Sensor No ' num2str(j)];

%%% --------------------------------------------------------------------------    
%    plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1) - mean(lowPassedData(1,min1:min1+100))),'linewidth',2,'color',col(5*i-1,:));
    figure(115)    
%     plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1) - mean(lowPassedData(1,min1:min1+100))),'linewidth',2,'color',col(5*i-1,:));
    plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1)),'linewidth',3,'color',col(5*i-1,:));
    
   %% boucle sur le nombre de periodes pour pouvoir effectuer les fits de la forme a.exp(-(t+d+t0)/tau1)*(1-exp(-(t+d+t0)/tau2))
   if make_fit==1
%        for iperiod = 1:(max1-min1)/period_beam_in_Bins
       for iperiod = 1:Nperiod
                           
           Lim2        = min2+(iperiod)  *period_beam_in_Bins;
           Lim0        = min2+(iperiod-1)*period_beam_in_Bins; 
           % periode temps et temp partie croissante 
           period_time   = timeFull(:,Lim0:Lim2) - time_shift; %% on retire 6 secondes pour etre toujours dans le meme range
           period_time   = period_time - min(period_time);
           period_temp   = 15*( lowPassedData(1,Lim0:Lim2));

           max_temp_period(i,iperiod)      =  max(period_temp);
           norm_max_temp(i,iperiod)        = (max_temp_period(i,iperiod) - min_period)/(max_period - min_period);

           fprintf('%d %d %g %g %g\n',i,iperiod,max_temp_period(i,iperiod),norm_max_temp(i,iperiod),max(period_temp));
%            subplot(5,5,Granular_sensor_positions(i))
%            set(gca,'Color',[norm_max_temp 0.1 0.9]);
%            pause(0.3)
         
       end
   end
%%% --------------------------------------------------------------------------    
   
% figure(115)    
% hold on
% for i=1:Nsensor+1
%     subplot(5,5,Granular_sensor_positions(i))
% end 





%     plot(min1:max1,                       15*( lowPassedData(1,min1:max1) - mean(lowPassedData(1,min1:min1+100))),'linewidth',2,'color',col(5*i-1,:));
%% Calculs dans les intervalles de periode du faisceau (ex : 1s ON, 5s OFF = 6s la periode)    
%% pour les fits il faudra plutot sauver pour chaque intervalle la points dans un tableau qui sera fitt? 
%% ne pas oublier le decalage utilise pour les droites permettant de separer chaque periode
   for ibin=1:floor((max1-min2)/Nbins_sec)+1
      max_jump(i,ibin)     = 15*max(lowPassedData(1,min2+(ibin-1)*Nbins_sec:min2+(ibin)*Nbins_sec))-corr_temp(i);
      raw_max_jump(i,ibin) = 15*(max(lowPassedData(1,min2+(ibin-1)*Nbins_sec:min2+(ibin)*Nbins_sec))-min(lowPassedData(1,min2+(ibin-1)*Nbins_sec:min2+(ibin)*Nbins_sec)));
      raw_time(i,ibin)     = timeFull(:,min2+(ibin-1)*Nbins_sec);
%      fprintf('%d %d %d %g %g \n',i,min2+(ibin-1)*Nbins_sec,min2+(ibin)*Nbins_sec,max(lowPassedData(1,min2+(ibin-1)*Nbins_sec:min2+(ibin)*Nbins_sec)),min(lowPassedData(1,min2+(ibin-1)*Nbins_sec:min2+(ibin)*Nbins_sec)) );
   end
    
   
% %   ylim(I_Axis_limits);
%     set(gca,'FontSize',20)
%     set(gcf, 'color', 'w');
%     xlhand = get(gca,'xlabel');
%     set(xlhand,'string','Time [sec]','fontsize',20);  
%     ylhand = get(gca,'ylabel');
%     set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  
%     legendInfo{i} = ['Sensor No ' num2str(j)];
end

figure(115)
legend(legendInfo,'FontSize',18);
 set(gca,'FontSize',20)
 set(gcf, 'color', 'w');
 xlhand = get(gca,'xlabel');
 set(xlhand,'string','Time [sec]','fontsize',20);  
 ylhand = get(gca,'ylabel');
 set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  
   
%%% plot les droites qui separent chaque periode de faisceau
figure(115)
for i=1:floor((max1-min2)/Nbins_sec)+1
    bin_droite=min2+(i-1)*Nbins_sec  ;
    plot([timeFull(:,bin_droite)- time_shift,timeFull(:,bin_droite)- time_shift], I_Axis_limits,'-')    
end




%%% plot les droites qui separent chaque periode de faisceau
figure(116)
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


% figure(115)
% legend(legendInfo,'FontSize',18);
% set(gca,'FontSize',20)
% set(gcf, 'color', 'w');
% xlhand = get(gca,'xlabel');
% set(xlhand,'string','Time [sec]','fontsize',20);  
% ylhand = get(gca,'ylabel');
% set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  
    

figure(222)
hold on
for i=1:Nsensor
    plot(max_jump(i,:),'linewidth',3,'color',col(5*i-1,:))
end
 legend(legendInfo,'FontSize',18);
 set(gca,'FontSize',20)
 set(gcf, 'color', 'w');
 xlhand = get(gca,'xlabel');
 set(xlhand,'string','Time [sec]','fontsize',20);  
 ylhand = get(gca,'ylabel');
 set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  
    
figure(223)
hold on
for i=1:Nsensor
%    plot(raw_max_jump(i,:),'linewidth',3,'color',col(5*i-1,:))
    plot(raw_time(i,:)-time_shift,raw_max_jump(i,:),'linewidth',3,'color',col(5*i-1,:))
end
legend(legendInfo,'FontSize',18);
 set(gca,'FontSize',20)
 set(gcf, 'color', 'w');
 xlhand = get(gca,'xlabel');
 set(xlhand,'string','Time [sec]','fontsize',20);  
 ylhand = get(gca,'ylabel');
 set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);  
    


