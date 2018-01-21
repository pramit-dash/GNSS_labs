%% GNSS labs Group2: lab5
% Main code would come here


%% ------------------ GPS timestamps to seconds ---------------------------
clear all
close all
clc

gps_week = 1499; % gps week

start_gps = 259263.5750014; % gps sec of week of data start
sat_1_gps = 259267.5750014; % gps sec of week acquisition of first satellite
TTFF_gps = 259759.5792914; % gps sec of week of TTFF

% conversion to year, month and decimal day
[yr_start, mn_start, dy_start]= jd2cal(gps2jd(gps_week,start_gps,0))
[yr_sat_1, mn_sat_1, dy_sat_1]= jd2cal(gps2jd(gps_week,sat_1_gps,0))
[yr_TTFF, mn_TTFF, dy_TTFF]= jd2cal(gps2jd(gps_week,TTFF_gps,0))

% time in seconds of acquisition of the first satellite
Sat_1_seconds = (dy_sat_1 - dy_start)*86400;

% time in seconds of TTFF
TTFF_seconds = (dy_TTFF - dy_start)*86400;

% sampling rate
first = 259263.5750014;
second = 259264.5750014;
[yr,mn,dy]= jd2cal(gps2jd(gps_week,first,0));
[yr2,mn2,dy2]= jd2cal(gps2jd(gps_week,second,0));
Rate = (dy2 - dy)*86400