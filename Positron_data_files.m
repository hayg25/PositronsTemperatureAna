function Positron_data_files()

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

figure(1)
for i=1:length(nameFolds)
    D = dir([basedir,char(nameFolds(i)),'/', '*.csv']);
    Nfiles = length(D(not([D.isdir])));
    fprintf('%d ----- Analyzed dir : %s  --> %d files --- \n',i,char(nameFolds(i)),Nfiles);    
end