function[timeFull,chanFull] =  CombineTempData(Data,Time)
% combine data coming from different files (one file = 1 min)
% into a single data (and time) array 
% data array will have (N=k*60000,9) size : 9 is the number of temperature sensors 


chanFull = zeros(0,0);
timeFull = zeros(0,0);
Taille=size(Data);

for i=1:Taille(1)
    chanFull = horzcat(chanFull,Data(i,:,:));
    timeFull = horzcat(timeFull,Time(i,:));
end
