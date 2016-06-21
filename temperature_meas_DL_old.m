
%%
%datafile = csvread('C:\Documents and Settings\LeCroyUser\My Documents\MATLAB\HybridSourceTemp\1006_2015_135802_292\datalogger$0test.csv')

%% Open more recent file

% [recent_folderpath, recent_file_listing] = get_recent_folder_DL;
% filename = fullfile(recent_folderpath,'\',recent_file_listing(end-1).name);
% fid = fopen(filename);
 
%% or specify

fid  = fopen('/Users/guler/Positrons/TestsAtKEK/datalogger$0$2.csv');
[header_struct]=read_header(fid);
fclose(fid);

fid  = fopen('/Users/guler/Positrons/TestsAtKEK/datalogger$0$2.csv');


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
 
 chanI = [data1{3:11}];
 chanI_Environment = [data1{12}];
 chanV = [data1{13:21}];
 
 figure(2)
 set(gca,'FontSize',16)
 plot(realTimeMT, chanV(:,1),'.-','LineWidth',0.9,'MarkerSize',6)
 hold off
 xlabel(' Time [sec]')
 ylabel('Voltage [mV]')
 
 figure(22)
 subplot 311
 set(gca,'FontSize',14)
 plot(realTimeMT, chanI,'.-','LineWidth',0.9,'MarkerSize',6)
 hold off
 %xlabel(' Time [sec]')
 ylabel('I [mA]')
 
 subplot 312
 set(gca,'FontSize',14)
 plot(realTimeMT, chanI_Environment,'.-','LineWidth',0.9,'MarkerSize',6)
 %xlabel(' Time [sec]')
 ylabel('I [mA]')
 
 subplot 313
 set(gca,'FontSize',14)
 plot(realTimeMT, chanV,'.-','LineWidth',0.9,'MarkerSize',6)
 hold off
 xlabel(' Time [sec]')
 ylabel('V [mV]')
 
 
pause(inf); 
 
 %% 1 sec time spand
 
 timeT = [data1{2}];
 chanI = [data1{3:11}];
 chanI_Environment = [data1{12}];
 chanV = [data1{13:21}];

 SamplingFreq = 1000; %Hz
 
figure(1)
set(gca,'FontSize',16)
plot(timeT(1:SamplingFreq)/1e6, chanI(1:SamplingFreq,:),'.-','LineWidth',0.9,'MarkerSize',6)
u = legend('Chan3','...', 'Chan12');
set(u,'Location','SouthEast','FontSize',14)
hold off
xlabel(' Time [sec]')
ylabel('Current [mA]')

figure(11)
set(gca,'FontSize',16)
plot(timeT(1:SamplingFreq)/1e6, chanI_Environment(1:SamplingFreq),'.-','LineWidth',0.9,'MarkerSize',6)
% u = legend('Chan3','...', 'Chan12');
% set(u,'Location','SouthEast','FontSize',14)
% hold off
xlabel(' Time [sec]')
ylabel('Current [mA]')
title('Environment temerature')

figure(2)
set(gca,'FontSize',16)
plot(timeT(1:SamplingFreq)/1e6, chanV(1:SamplingFreq,:),'.-','LineWidth',0.9,'MarkerSize',6)
u = legend('Chan13','...', 'Chan21');
set(u,'Location','SouthEast','FontSize',14)
hold off
xlabel(' Time [sec]')
ylabel('Voltage [mV]')
 
figure(22)
subplot 311
set(gca,'FontSize',14)
plot(timeT(1:SamplingFreq)/1e6, chanI(1:SamplingFreq,:),'.-','LineWidth',0.9,'MarkerSize',6)
hold off
%xlabel(' Time [sec]')
ylabel('I [mA]')

subplot 312
set(gca,'FontSize',14)
plot(timeT(1:SamplingFreq)/1e6, chanI_Environment(1:SamplingFreq),'.-','LineWidth',0.9,'MarkerSize',6)
%xlabel(' Time [sec]')
ylabel('I [mA]')

subplot 313
set(gca,'FontSize',14)
plot(timeT(1:SamplingFreq)/1e6, chanV(1:SamplingFreq,:),'.-','LineWidth',0.9,'MarkerSize',6)
hold off
xlabel(' Time [sec]')
ylabel('V [mV]')


%% 50 Hz issue / filter???



%% Plot the Temperature for granular target

% Environment temerature

 timeT = [data1{2}];
 chanI = [data1{3:11}];
 chanI_Environment = [data1{12}];
 chanV = [data1{13:21}];
 deltaChanI = chanI - chanV;

 SamplingFreq = 2000; %Hz






%% Temperature map

 








 %% Long period/ Continuous
 
