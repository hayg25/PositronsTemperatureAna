function [ temp_header ] = read_header( read_file )
% read temperature header
%  Until keyword 'EndHeader'
%  variables to keep : Time of Starting Acq.
%  Sampling Rate (be careful to micro seconds)
%  No. of Data
%  Channel Number  (1)HA-V01,(1)HA-V02,...,(2)HA-C02,(2)HA-C03
%  Waveform Name,,"Voltage01","Voltage02","Voltage03" ...
%  Input Range,,}500mV,}500mV,}500mV,
%  Unit,,"mV","mV","mV","mV","mV","mV","mV","mA","mA","mA"
%  --> Should create and return a strucure 

%    temp_header = struct;

    
    temp_header.ACQ_Start_Time=0;
    temp_header.Sampling_Rate=0;
    temp_header.No_Of_Data=0;
    
    temp_header.Channel_Number=[];
    temp_header.WF_Name       =[];
    temp_header.Input_Range   =[];
    temp_header.Units         =[];
    
   
%    read_file = fopen(temperature_file,'r'); % will be entered as argument  

    end_header=[];
    line_id=0;
    while isempty(end_header)
        line_id=line_id+1;
        line  = fgetl(read_file);
        split_line = strsplit(line,',');        
%        fprintf('%d -- %d -- %s \n',line_id,length(split_line),line);
        end_header = strfind(line,'EndHeader');
        
        if strfind(line,'Channel Number')
           temp_header.Channel_Number=split_line(3:end); 
        elseif strfind(line,'Waveform Name')
           temp_header.WF_Name=split_line(3:end); 
        elseif strfind(line,'Input Range')
           temp_header.Input_Range=split_line(3:end); 
        elseif strfind(line,'Unit')
           temp_header.Units=split_line(3:end); 
        elseif strfind(line,'Time of Starting Acq.')
           temp_header.ACQ_Start_Time=split_line(2); 
        elseif strfind(line,'Sampling Rate')
           temp_header.Sampling_Rate=split_line(2); 
           %% treat the mus stuff and unit stuff
           if strfind(char(temp_header.Sampling_Rate),'ƒÊs')
               sr=strrep(char(temp_header.Sampling_Rate),'ƒÊs','');
               temp_header.Sampling_Rate=str2num(sr(1))*1.0e-6; % mus to seconds
           elseif  strfind(char(temp_header.Sampling_Rate),'ms')
               sr=strrep(char(temp_header.Sampling_Rate),'ms','');
               temp_header.Sampling_Rate=str2num(sr(1))*1.0e-3; % ms to seconds               
           end     
        elseif strfind(line,'No. of Data')
           temp_header.No_Of_Data=split_line(2); 
        end             
    end 
    
    
end





