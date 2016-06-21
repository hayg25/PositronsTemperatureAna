function[chanI_Env,chanI,realTime,DeltaTime] =  Loop_over_temp_data(id0)
close all 

basedir='/Volumes/LACIE_HAYG/Positron_DATA_KEK_Oct2015/Temperature_DATA/';
d = dir(basedir);
% 41x1 struct array with fields:
% 
%     name
%     date
%     bytes
%     isdir
%     datenum

% list of subfolders 
isub = [d(:).isdir];
% Name of subfolders 
nameFolds = {d(isub).name}';
% subtract . and .. from the list
nameFolds(ismember(nameFolds,{'.','..'})) = [];



% filedir='1011_2015_033606_054/';
% filedir='1011_2015_160455_206/';
% filedir='1011_2015_163832_298/'; % 25 Hz Pattern 
% filedir='1011_2015_164237_235/'; % 25Hz/10Hz/5Hz Pattern
% filedir='1011_2015_170522_551/';
% filedir='1011_2015_172518_794/';



p1 = 15.0053;


figure(1)
for i=1:length(nameFolds)
    fprintf('%d ----- Analyzed dir : %s\n',i,char(nameFolds(i)));    
end


hold on 
% id0=23
for idi=1:length(nameFolds)
    
    if idi ~= id0 
        continue 
    end
    fprintf('----- Analyzed dir : %s\n',char(nameFolds(idi)));
    D = dir([basedir,char(nameFolds(idi)),'/', '*.csv']);
    Nfiles = length(D(not([D.isdir])));
    if Nfiles>1 
        Nfiles = Nfiles-1;
    end
    fprintf('--> Directory contains : %d Files \n',Nfiles);
    
      for i=1:Nfiles         
%      for i=1:1
%         basedir 
%         char(nameFolds(idi))
        opened_file=sprintf('%s%s/positrons$0$%d.csv',basedir,char(nameFolds(idi)),i-1);
%         fprintf('opened file --> %s\n',opened_file);
        [chanI_Env(i,:,:),chanI(i,:,:),realTime(i,:,:),DeltaTime(i,:,:)] = temp_meas_1s(opened_file);
        plot(DeltaTime(i,:,:),p1*chanI(i,:,1));
    end
end 



% Fit temperature calibration law

