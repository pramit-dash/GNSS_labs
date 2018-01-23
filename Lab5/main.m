%% GNSS labs Group2: lab5
clear all
close all
clc

%% ------------------------- reading text file ----------------------------
fid = fopen('GNSSlab_B_corrected.txt');
tline = fgetl(fid);
tlines = cell(0,1);
while ischar(tline)
    tlines{end+1,1} = tline;
    tline = fgetl(fid);
end
fclose(fid);

% Find the tlines with F40, F80, F62 messages
messLines_40 = regexp(tlines,'F40','match','once');
eqnLineMask_40 = ~cellfun(@isempty, messLines_40);
F_40 = tlines(eqnLineMask_40==1);

messLines_62 = regexp(tlines,'F62','match','once');
eqnLineMask_62 = ~cellfun(@isempty, messLines_62);
F_62 = tlines(eqnLineMask_62==1);

messLines_80 = regexp(tlines,'F80','match','once');
eqnLineMask_80 = ~cellfun(@isempty, messLines_80);
F_80 = tlines(eqnLineMask_80==1);

% extract columns of interest 
No_tracked_sats = extractBetween(F_40,97,97); % tracked satellites
sats = str2double(No_tracked_sats);

figure(1)
histogram(sats)
title('Number of Tracked Satellites (whole data set)')
xlabel('Number of Satellites')
ylabel('Number of Occurence')
xlim([-0.5 9.5]);

%% -------------- splitting the data set into two periods -----------------
initialization = regexp(F_40,'14.2000014','match','once');
init = str2double(initialization);
ix = find(init==14.2000014);

figure(2)
period_1_sats = sats(1:ix(1)); % period 1:before reinitialization
histogram(period_1_sats)
title('Number of Tracked Satellites - Period 1')
xlabel('Number of Satellites')
ylabel('Number of Occurence')
xlim([-0.5 9.5]);

figure(3)
period_2_sats = sats(ix(1):length(sats)); % period 2:after reinitialization
histogram(period_2_sats)
title('Number of Tracked Satellites - Period 2')
xlabel('Number of Satellites')
ylabel('Number of Occurence')
xlim([-0.5 9.5]);

%% --------------------------- Range rates --------------------------------
range_rates_ch1 = str2double(extractBetween(F_62(22:length(F_62)),64,73));
range_rates_ch2 = str2double(extractBetween(F_62(22:length(F_62)),111,120));
range_rates_ch3 = str2double(extractBetween(F_62(22:length(F_62)),158,167));
range_rates_ch4 = str2double(extractBetween(F_62(22:length(F_62)),205,214));
range_rates_ch5 = str2double(extractBetween(F_62(22:length(F_62)),252,261));
range_rates_ch6 = str2double(extractBetween(F_62(22:length(F_62)),299,308));
range_rates_ch7 = str2double(extractBetween(F_62(22:length(F_62)),346,355));
range_rates_ch8 = str2double(extractBetween(F_62(22:length(F_62)),393,402));
range_rates_ch9 = str2double(extractBetween(F_62(22:length(F_62)),440,449));
range_rates_ch10 = str2double(extractBetween(F_62(22:length(F_62)),487,496));
range_rates_ch11 = str2double(extractBetween(F_62(22:length(F_62)),534,543));
range_rates_ch12 = str2double(extractBetween(F_62(22:length(F_62)),581,590));

range_rates = [range_rates_ch1 range_rates_ch2 range_rates_ch3...
    range_rates_ch4 range_rates_ch5 range_rates_ch6 range_rates_ch7...
    range_rates_ch8 range_rates_ch9 range_rates_ch10 range_rates_ch11...
    range_rates_ch12];

%% ---------------------- PRNs in each channel ----------------------------
PRNs_ch1 = str2double(extractBetween(F_62(22:length(F_62)),35,37));
PRNs_ch2 = str2double(extractBetween(F_62(22:length(F_62)),82,84));
PRNs_ch3 = str2double(extractBetween(F_62(22:length(F_62)),129,131));
PRNs_ch4 = str2double(extractBetween(F_62(22:length(F_62)),176,178));
PRNs_ch5 = str2double(extractBetween(F_62(22:length(F_62)),223,225));
PRNs_ch6 = str2double(extractBetween(F_62(22:length(F_62)),270,272));
PRNs_ch7 = str2double(extractBetween(F_62(22:length(F_62)),317,319));
PRNs_ch8 = str2double(extractBetween(F_62(22:length(F_62)),364,366));
PRNs_ch9 = str2double(extractBetween(F_62(22:length(F_62)),411,413));
PRNs_ch10 = str2double(extractBetween(F_62(22:length(F_62)),458,460));
PRNs_ch11 = str2double(extractBetween(F_62(22:length(F_62)),505,507));
PRNs_ch12 = str2double(extractBetween(F_62(22:length(F_62)),552,554));

PRNs = [PRNs_ch1 PRNs_ch2 PRNs_ch3 PRNs_ch4 PRNs_ch5 PRNs_ch6 PRNs_ch7...
    PRNs_ch8 PRNs_ch9 PRNs_ch10 PRNs_ch11 PRNs_ch12];


%% ---------- plotting specific PRNs in specific channels -----------------
figure(4)
plot(range_rates_ch1(find(PRNs_ch1==19)))
title('Range-rates for PRN 19 - Channel 1')
xlabel('Number of Observations')
ylabel('Range-rates [m/s]')

figure(5)
plot(range_rates_ch1(find(PRNs_ch1==7)))
title('Range-rates for PRN 07 - Channel 1')
xlabel('Number of Observations')
ylabel('Range-rates [m/s]')

figure(6)
plot(range_rates_ch1(find(PRNs_ch2==23)))
title('Range-rates for PRN 23 - Channel 2')
xlabel('Number of Observations')
ylabel('Range-rates [m/s]')

figure(7)
plot(range_rates_ch1(find(PRNs_ch3==21)))
title('Range-rates for PRN 21 - Channel 2')
xlabel('Number of Observations')
ylabel('Range-rates [m/s]')
%% ------------------------ Peak Doppler Shifts ---------------------------
Peak_Dopplers = max(range_rates); % in m/s
%% --------------------- Line-of-sight accelerations ----------------------
LOS = diff(range_rates);
Peak_LOS = max(LOS);
%% -------------- Jerk values (derivative of acceleration) ---------------- 
Jerk = diff(LOS);
Peak_Jerk = max(Jerk);

%% ---------- Extracting Position and Velocity from F40 & F80 -------------

time_stamps_40 = str2double(extractBetween(F_40,5,23)); 
time_stamps_40_1 = time_stamps_40(1:ix,:);

time_stamps_80 = str2double(extractBetween(F_80,5,23)); 
time_stamps_80_1 = time_stamps_80(1:ix,:);

% ---------------------------- position -----------------------------------
x_40 = extractBetween(F_40,24,35); 
y_40 = extractBetween(F_40,36,47);
z_40 = extractBetween(F_40,48,59); 
Pos_40 = str2double([x_40 y_40 z_40]);
Pos_40_1 = Pos_40(1:ix,:);

x_80 = extractBetween(F_80,24,35);
y_80 = extractBetween(F_80,36,47); 
z_80 = extractBetween(F_80,48,59); 
Pos_80 = str2double([x_80 y_80 z_80]);
Pos_80_1 = Pos_80(1:ix,:);

[timestamps,iA,iB] = intersect(time_stamps_40_1,time_stamps_80_1); 
Pos_40_new = Pos_40(iA,:);
Pos_80_new = Pos_80(iB,:);

figure(9)
plot(Pos_40_new)

figure(10)
plot(Pos_80_new)

% ---------------------------- velocity -----------------------------------
vx_40 = extractBetween(F_40,60,71); 
vy_40 = extractBetween(F_40,72,83); 
vz_40 = extractBetween(F_40,84,95); 
Vel_40 = str2double([vx_40 vy_40 vz_40]);
Vel_40_1 = Vel_40(1:ix,:);

vx_80 = extractBetween(F_80,60,71); 
vy_80 = extractBetween(F_80,72,83); 
vz_80 = extractBetween(F_80,84,95); 
Vel_80 = str2double([vx_80 vy_80 vz_80]);
Vel_80_1 = Vel_80(1:ix,:);

[~,iA,iB] = intersect(time_stamps_40_1,time_stamps_80_1); 
Vel_40_new = Vel_40(iA,:);
Vel_80_new = Vel_80(iB,:);

figure(9)
plot(Vel_40_new)

figure(10)
plot(Vel_80_new)

% ----------------------- position error ----------------------------------
% F80 is given later, (it is 0.00 while F40 has values, so the first values
% are being ignored)
Pos_error = Pos_80_new(532:end,:) - Pos_40_new(532:end,:);
figure(11)
plot(timestamps(532:end),Pos_error)


% ----------------------- velocity error ----------------------------------
Vel_error = Vel_80_new(532:end,:) - Vel_40_new(532:end,:);
figure(12)
plot(timestamps(532:end),Vel_error)
