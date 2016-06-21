
%%
%datafile = csvread('C:\Documents and Settings\LeCroyUser\My Documents\MATLAB\HybridSourceTemp\1006_2015_135802_292\datalogger$0test.csv')

%% Open more recent file

% [recent_folderpath, recent_file_listing] = get_recent_folder_DL;
% filename = fullfile(recent_folderpath,'\',recent_file_listing(end-1).name);
% fid = fopen(filename);
 
%% or specify
close all
clc
fid = fopen('/Users/guler/Positrons/TestsAtKEK/TemperatureData/positrons$0$1.csv');

%fid  = fopen('/Users/guler/Positrons/TestsAtKEK/datalogger$0$2.csv');
[header_struct]=read_header(fid);
fclose(fid);

fid = fopen('/Users/guler/Positrons/TestsAtKEK/TemperatureData/positrons$0$1.csv');
%fid  = fopen('/Users/guler/Positrons/TestsAtKEK/datalogger$0$2.csv');


%%


 if fid>0
     data = textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',','HeaderLines',71);

     %data = textscan(fid,'%s %f %f','Delimiter',',','HeaderLines',71);
     fclose(fid);   
     for iC = 1:length(data)         
         if iC==1
             data1{iC} = data{iC}(1:end-2, :);
         else
             data1{iC} = data{iC}(1:end-1, :);
         end
     end
 else 
     fprintf('------  Files does not exist ... \n');
 end
  
 subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02 0.01], [0.02 0.02 0.01], [0.02 0.02 0.01]);

 %%
 
 tt = [data1{1}];
 tts = char(tt);
 refTime = datenum(tts,'mm/dd/yyyy HH:MM:SS');%,'mm/dd/yyyy HH.MM.SS')
 timeT = [1e-6*data1{2}]; 
 Nsec = datestr(timeT/86400, 'HH:MM:SS:FFF');
 Time_1Jan_2015=datenum('1-Jan-2015');
 NsecMT =datenum(Nsec,'HH:MM:SS:FFF')-Time_1Jan_2015;
 DeltaDate = refTime - datenum(header_struct.ACQ_Start_Time);
 %--- time in seconds----
 realTimeMT =86400*( refTime+NsecMT-datenum(header_struct.ACQ_Start_Time));
% realTime = datestr(realTimeMT, 'HH:MM:SS:FFF');

 %%
 
 chanV = [data1{3:9}];
 chanI = [data1{10:18}];
 chanI_Environment = [data1{19}];
%  
%  figure(2)
%  set(gca,'FontSize',16)
%  plot(realTimeMT, chanV(:,1),'.-','LineWidth',0.9,'MarkerSize',6)
%  hold off
%  xlabel(' Time [sec]')
%  ylabel('Voltage [mV]')
%  
%  figure(22)
%  subplot 311
%  set(gca,'FontSize',14)
%  plot(realTimeMT, chanI,'.-','LineWidth',0.9,'MarkerSize',6)
%  hold off
%  %xlabel(' Time [sec]')
%  ylabel('I [mA]')
%  
%  subplot 312
%  set(gca,'FontSize',14)
%  plot(realTimeMT, chanI_Environment,'.-','LineWidth',0.9,'MarkerSize',6)
%  %xlabel(' Time [sec]')
%  ylabel('I [mA]')
%  
%  subplot 313
%  set(gca,'FontSize',14)
%  plot(realTimeMT, chanV,'.-','LineWidth',0.9,'MarkerSize',6)
%  hold off
%  xlabel(' Time [sec]')
%  ylabel('V [mV]')
%  
 

%% 50 Hz issue / filter???



%% Plot the Temperature for granular target

 figure (33)
 I_Axis_limits=[1.3,1.7];  
 V_Axis_limits=[0,200];  
%-----------------------------------------------
 Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
 for i=1:9
    subplot(5,5,Granular_sensor_positions(i))
    plot(realTimeMT,chanI(:,i));
    ylim(I_Axis_limits);
    title(sprintf('Sensor (%d)',i));
    set(gca,'FontSize',12)
    hold off
    if i==8
        xlabel(' Time [sec]')
    end
    if i==9
        ylabel('I [mA]')
    end
 end
 
%---Temperature ---------------------------------- 
%--- Obtained by Rough linear fitting ----- 
Coef_1_FIT=15.035;
Coef_2_FIT=-0.39;


Size_chanI=size(chanI);
for i=1:Size_chanI(2)
    for j=1:Size_chanI(1)
        chanT(j,i)=Coef_1_FIT * chanI(j,i) + Coef_2_FIT;
    end
end


 figure (43)
 T_Axis_limits=[0,100];  
 V_Axis_limits=[0,200];  
 Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
 for i=1:9
    subplot(5,5,Granular_sensor_positions(i))
    plot(realTimeMT,chanT(:,i));
    ylim(T_Axis_limits);
    title(sprintf('Sensor (%d)',i));
    set(gca,'FontSize',14)
    hold off
    if i==8
        xlabel(' Time [sec]')
    end
    if i==9
        ylabel('T [?C]')
    end
 end
 
%-------- Plot Temp Histogram -----------------
 figure (45)
 T_Axis_limits=[0,100];  
 V_Axis_limits=[0,200];  
 Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
 for i=1:9
    subplot(5,5,Granular_sensor_positions(i))
    hist(chanT(:,i));
    title(sprintf('Sensor (%d)',i));
    set(gca,'FontSize',14)
    hold off
    if i==8
        xlabel(' Time [sec]')
    end
    if i==9
        ylabel('T [?C]')
    end
 
 end
 
%-----------------------------------------------
 figure (34)
 Compact_sensor_positions=[13,8,3,14,15,18,12];
 Compact_sensor_ID=[1,2,3,4,5,6,8]; % 7 and 9 broken ?

 for i=1:7
    subplot(5,5,Compact_sensor_positions(i))
    plot(realTimeMT,chanV(:,i));
    ylim(V_Axis_limits)
    title(sprintf('Sensor (%d)',Compact_sensor_ID(i)));
    set(gca,'FontSize',14)
    hold off
    xlabel(' Time [sec]')
    ylabel('V [mV]')

    if i==6
        xlabel(' Time [sec]')
    end
    
    if i==7
        ylabel('I [mA]')
    end
 end
%--------------Reference Target ------------------
 figure (37)
 Axis_limits=[0,5];  

 Compact_sensor_positions=[10,6,2,11,12,14,9];
 Compact_sensor_ID=[1,2,3,4,5,6,8]; % 7 and 9 broken ?

 for i=1:7
    subplot(4,4,Compact_sensor_positions(i))
    plot(realTimeMT,chanV(:,i));
    ylim(V_Axis_limits)
    title(sprintf('Sensor (%d)',Compact_sensor_ID(i)));
    set(gca,'FontSize',14)
    hold off
    xlabel(' Time [sec]')
    ylabel('V [mV]')

    if i==6
        xlabel(' Time [sec]')
    end
    
    if i==7
        ylabel('I [mA]')
    end
 end
 
 %-----------------Environment temperature -----------------
 figure (35)

subplot(1,1,1)
plot(realTimeMT,chanI_Environment(:));
ylim(I_Axis_limits)
set(gca,'FontSize',14)
hold off
xlabel(' Time [sec]')
ylabel('I [mA]')
 





%% Temperature map

 








 %% Long period/ Continuous
 
