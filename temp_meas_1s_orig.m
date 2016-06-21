function[chanI_Environment,chanI,realTimeMT,DeltaDate] = temp_meas_1s(imput_file)

% fich=strcat(imput_file);
fich=imput_file;
 

%fich='/Volumes/LACIE_HAYG/Positron_DATA_KEK_Oct2015/Temperature_DATA/1011_2015_033606_054/positrons$0$12.csv';
%fich='/Volumes/LACIE_HAYG/Positron_DATA_KEK_Oct2015/Temperature_DATA/1012_2015_182609_051/positrons$0$0.csv'
fid = fopen(fich);
[header_struct]=read_header(fid);
fclose(fid);
fid = fopen(fich);


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
  
% subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02 0.01], [0.02 0.02 0.01], [0.02 0.02 0.01]);

 %%
 
 tt = [data1{1}];
 tts = char(tt);
 
 refTime = datenum(tts,'mm/dd/yyyy HH:MM:SS');%,'mm/dd/yyyy HH.MM.SS')
 timeT = [1e-6*data1{2}];
 Nsec = datestr(timeT/86400, 'HH:MM:SS:FFF');
 Time_1Jan_2015=datenum('1-Jan-2015');
 NsecMT =datenum(Nsec,'HH:MM:SS:FFF')-Time_1Jan_2015;
 DeltaDate = (refTime - datenum(header_struct.ACQ_Start_Time))*86400+timeT;
%  DeltaDate = timeT*1000;   
 
%  for i=1:6000
%      fprintf('%d ---- %d %d %d %d \n',i,refTime(i),timeT(i),Nsec(i),NsecMT(i));
%  end
 
 
 %--- time in seconds----
 realTimeMT =86400*( refTime+NsecMT-datenum(header_struct.ACQ_Start_Time));
% realTime = datestr(realTimeMT, 'HH:MM:SS:FFF');

 %%
 
 chanV = [data1{3:9}];
 chanI = [data1{10:18}];
 chanI_Environment = [data1{19}];


%% Plot the Temperature for granular target

%  figure (33)
%  I_Axis_limits=[1.3,5];  
%  V_Axis_limits=[100,120];  
% %-----------------------------------------------
%  Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
%  for i=1:9
%     subplot(5,5,Granular_sensor_positions(i))
%     plot(realTimeMT(1:N_pulse_1s),chanI(1:N_pulse_1s,i));
%     ylim(I_Axis_limits);
%     title(sprintf('Sensor (%d)',i));
%     set(gca,'FontSize',12)
%     hold off
%     if i==8
%         xlabel(' Time [sec]')
%     end
%     if i==9
%         ylabel('I [mA]')
%     end
%  end
%  
% subplot(5,5,25)
% plot(realTimeMT(1:N_pulse_1s),chanI_Environment(1:N_pulse_1s));
% ylim(I_Axis_limits)
% set(gca,'FontSize',14)
% hold off
% xlabel(' Time [sec]')
% ylabel('I [mA]')
% 
