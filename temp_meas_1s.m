function[chanI_Environment,chanI,realTimeMT,DeltaDate] = temp_meas_1s(imput_file)

% fich=strcat(imput_file);

fich=imput_file;
fid = fopen(fich);
[header_struct]=read_header(fid);
fclose(fid);
fid = fopen(fich);


 if fid>0
     %data = textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',','HeaderLines',71);
     %__________ data structure for the last run 
     data = textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',','HeaderLines',71);

     %data = textscan(fid,'%s %f %f','Delimiter',',','HeaderLines',71);
     fclose(fid);   
%      length(data) 
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
 refTime = datenum(tts,'mm/dd/yyyy HH:MM:SS');
 %,'mm/dd/yyyy HH.MM.SS')

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

%  chanV = [data1{3:10}];
%  chanI = [data1{11:19}];
%  chanI_Environment = [data1{20}];

%% 
