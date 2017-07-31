
function [cur_set, fz, gain]=ctle_set(prev_set)
%clc
%close all;
clear all

global ctle_adapt;
%fp1=9.8e9;
%fp2=1e12;
%fp1=9.8e9;
%fp2=15.5e10;

max_set=11;
min_set=1;

if(prev_set<max_set && prev_set>min_set)
    cur_set=prev_set+ctle_adapt;
else
    cur_set=prev_set;
end

switch cur_set
    case 1
        %ctle=ctle(3, 5.5e9,12); % (signal, fz, gain)
        fz=5.5e9;
        gain=12;
    case 2     
        %ctle=ctle(3, 2e9, 12); % (signal, fz, gain)
        fz=4.5e9;
        gain=12;
    case 3
        %ctle=ctle(3, 3.5e9, 12); % (signal, fz, gain)
        fz=3.5e9;
        gain=12;
    case 4
        fz=2.5e9;
        gain=12;
    case 5
        fz=2.5e9;
        gain=12;
    case 6
        fz=2e9;
        gain=12;
    case 7 % start set
        fz=1.5e9;
        gain=12;
    case 8
        fz=1.2e9;
        gain=12;
    case 9
        fz=1e9;
        gain=12;
    case 10
        fz=0.7e9;
        gain=12;
    case 11
        fz=0.4e9;
        gain=12;
end
        
%ctle=ctle(3, 1.2e9, 12); % (signal, fz, gain)
%ctle=ctle(3, 1e9, 12); % (signal, fz, gain)
%ctle=ctle(3, 0.7e9, 12); % (signal, fz, gain)
%ctle=ctle(3, 0.4e9, 12); % (signal, fz, gain)
%ctle=ctle(3, 2.5e9, 12); % (signal, fz, gain)
%ctle=ctle(3, 2.8e9, 12); % (signal, fz, gain)
%ctle=ctle(3, 3.5e9, 12); % (signal, fz, gain)
%ctle=ctle(3, 4.5e9, 12); % (signal, fz, gain)
%ctle=ctle(3, 5.5e9, 12); % (signal, fz, gain)

