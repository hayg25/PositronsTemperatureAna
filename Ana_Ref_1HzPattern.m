% function[Corr_data,timeFull,chanFull,chanRef,delta_temp,raw_max_jump,a,t0,tau1,tau2] =  Ana_Ref_ZeroRef(refData,chanData,Time,min1,max1,butter_cut,min2)
%function[a1,tau1,a2,tau2] =  Ana_Ref_1HzPattern(refData,chanData,Time,min1,max1,butter_cut,min2,make_fit)
% function[period_time_all,period_temp_all] =  Ana_Ref_1HzPattern(refData,chanData,Time,min1,max1,butter_cut,min2,make_fit)

% function[a1,tau1,a2,tau2,rsquare]         =  Ana_Ref_1HzPattern(refData,chanData,Time,min1,max1,butter_cut,min2,make_fit,calc_fit)
% function[max_jump,raw_max_jump]   =  Ana_Ref_1HzPattern(refData,chanData,Time,min1,max1,butter_cut,min2,make_fit,calc_fit)
function[timeFull_out,Sig_out]   =  Ana_Ref_1HzPattern(refData,chanData,Time,min1,max1,butter_cut,min2,make_fit,calc_fit)
   

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

size(chanFull)

subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.02 0.01], [0.04 0.02 0.01], [0.04 0.02 0.01]);
% I_Axis_limits=[-0.2,0.3];
% I_Axis_limits=[0.2,0.7];
I_Axis_limits=[-2,9];
% I_Axis_limits=[20,30];
% I_Axis_limits=[-0.01,0.15];

Nbins_sec=6000;
% Nbins_sec=12000;
%  Nbins_sec=2000;
% time_shift=558.3;
% time_shift=1.73;
% time_shift=5280;


period_beam_in_Bins = Nbins_sec; % 1s for 1 period = [1s ON, 1s OFF]
%time_shift=540.3;
time_shift=60;
 
 
% plo_id=[9,5,1,3,7]
plo_id=[1:9]
% for i=1:9

max_jump=zeros(Nsensor,floor((max1-min2)/Nbins_sec));
raw_max_jump=zeros(Nsensor,floor((max1-min2)/Nbins_sec));

a1      = zeros(Nsensor,floor((max1-min2)/Nbins_sec)+1);
tau1    = zeros(Nsensor,floor((max1-min2)/Nbins_sec)+1);
a2      = zeros(Nsensor,floor((max1-min2)/Nbins_sec)+1);
tau2    = zeros(Nsensor,floor((max1-min2)/Nbins_sec)+1);
rsquare = zeros(Nsensor,floor((max1-min2)/Nbins_sec)+1);




min_temp=zeros(Nsensor);
max_temp=zeros(Nsensor);
delta_temp=zeros(Nsensor);
corr_temp=zeros(Nsensor);

for i=1:Nsensor
% for i=1:1
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
%    plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1) - mean(lowPassedData(1,min1:min1+100))),'linewidth',2,'color',col(5*i-1,:));
   plot(timeFull(:,min1:max1) -  time_shift,15*( lowPassedData(1,min1:max1) - min(lowPassedData(1,min1:max1))),'linewidth',4,'color',col(5*i-1,:));
%    plot(timeFull(:,min1:max1) -  time_shift+0.15,5*( chanFull(1,min1:max1,1) - min(lowPassedData(1,min1:max1))),'linewidth',1,'color','r');
   
   timeFull_out = timeFull(:,min1:max1) -  time_shift;
   Sig_out      = 15*( lowPassedData(1,min1:max1) - min(lowPassedData(1,min1:max1) ) );
   
   
   %% boucle sur le nombre de periodes pour pouvoir effectuer les fits de la forme a.exp(-(t+d+t0)/tau1)*(1-exp(-(t+d+t0)/tau2))

   figure(122)

   if make_fit==1
       for iperiod = 1:(max1-min1)/period_beam_in_Bins
           n_row = floor(sqrt((max1-min1)/period_beam_in_Bins))+1;
           subplot(n_row,n_row,iperiod);
           hold on   

%            fprintf('iperiod : %d %d %d  \n',iperiod,max1-min1,period_beam_in_Bins);       
    %        plot(timeFull(:,min1+(iperiod-1)*period_beam_in_Bins:min1+(iperiod)*period_beam_in_Bins) - time_shift,15*( lowPassedData(1,min1+(iperiod-1)*period_beam_in_Bins:min1+(iperiod)*period_beam_in_Bins) - mean(lowPassedData(1,min1:min1+100))),'linewidth',2,'color',col(5*i-1,:));

           myfittype = fittype('a1*exp(tau1*x)+a2*exp(tau2*x)','coefficients',{'a1','tau1','a2','tau2'});

           Lim1        = min2+(iperiod-1)*period_beam_in_Bins + floor(period_beam_in_Bins/6.); %% start from peak position to fit only decrease
           Lim2        = min2+(iperiod)  *period_beam_in_Bins;
           Lim0        = min2+(iperiod-1)*period_beam_in_Bins; 

           temp_shift  = mean(lowPassedData(1,min1:min1+100));


           % periode temps et temp partie croissante 
           period_time_all   = timeFull(:,Lim0:Lim2) - time_shift; %% on retire 6 secondes pour etre toujours dans le meme range
           period_time_all   = period_time_all - min(period_time_all);
           period_temp_all   = 15*( lowPassedData(1,Lim0:Lim2) - temp_shift);


%            fprintf('%d %g %g \n', min(period_time_all), max(period_time_all),iperiod);

           options  = fitoptions('Method','NonlinearLeastSquares','StartPoint',[-0.15,-19,0.12,-3]) ;


          plot(period_time_all ,period_temp_all,'--mo')

          if calc_fit ==1  
              [myfit,gof]   = fit(period_time_all',period_temp_all',myfittype,options)
              pl1 = plot(myfit);   
              set(pl1,'Color','r','LineWidth',2)
          
             
              a1(i,iperiod)       = myfit.a1;
              tau1(i,iperiod)     = myfit.tau1;
              a2(i,iperiod)       = myfit.a2;
              tau2(i,iperiod)     = myfit.tau2;
              rsquare(i,iperiod)  = gof.rsquare;
          end
          xlim([0,1]);

          set(gca,'FontSize',20)
          set(gcf, 'color', 'w');
          xlhand = get(gca,'xlabel');
          set(xlhand,'string','Time [sec]','fontsize',20);  
          ylhand = get(gca,'ylabel');
          set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',20);     
       end
   end
   
   %%% --------------------------------------------------------------------------
   


%     plot(min1:max1,                       15*( lowPassedData(1,min1:max1) - mean(lowPassedData(1,min1:min1+100))),'linewidth',2,'color',col(5*i-1,:));
%% Calculs dans les intervalles de periode du faisceau (ex : 1s ON, 5s OFF = 6s la periode)    
%% pour les fits il faudra plutot sauver pour chaque intervalle la points dans un tableau qui sera fitt? 
%% ne pas oublier le decalage utilise pour les droites permettant de separer chaque periode

size(lowPassedData)
    for ibin=1:floor((max1-min2)/Nbins_sec)
        fprintf('------------  %d %d %d \n',ibin,min2+(ibin-1)*Nbins_sec,min2+(ibin)*Nbins_sec);
        
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
    lin_pl = plot([timeFull(:,bin_droite)- time_shift,timeFull(:,bin_droite)- time_shift], I_Axis_limits,'-');    
% %   plot([bin_droite,bin_droite]- time_shift                                    , I_Axis_limits,'-')    
    set(lin_pl,'Color','k','LineWidth',2);
end

%%% Ref data -- 
signal_fft=fft(chanRef(1,:));
%% Low pass filter
[b,a]=butter(8,[butter_cut]/(1000),'low');
lowPassedRefData=filter(b,a,chanRef(1,:));


figure(115)
legend(legendInfo,'FontSize',22);
set(gca,'FontSize',24)
set(gcf, 'color', 'w');
xlhand = get(gca,'xlabel');
set(xlhand,'string','Time [sec]','fontsize',24);  
ylhand = get(gca,'ylabel');
set(ylhand,'string','Temperature increase [^{\circ}C]','fontsize',24);  
    
% 
% figure(222)
% hold on
% for i=1:Nsensor
%     plot(max_jump(i,:),'linewidth',2,'color',col(5*i-1,:))
% end
%  legend(legendInfo,'FontSize',18);
% 
% figure(223)
% hold on
% for i=1:Nsensor
%     plot(raw_max_jump(i,:),'linewidth',2,'color',col(5*i-1,:))
% end
%  legend(legendInfo,'FontSize',18);



