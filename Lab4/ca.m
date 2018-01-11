%%%
% Description: Generates C/A code for a given satellite PRN.
% Inputs: GPS Satellite PRN between 1 and 32
% Outputs: CA code

function [ code ] = ca( PRN )
%PRN = 1;
if (PRN>32)||(PRN<1) % Error checking
    error('PRN must be between 1 and 32\n')
end

intcheck=round(PRN)-PRN;
if intcheck ~= 0
 warning('non-integer value entered for PRN, rounding to closestinteger\n');
 PRN = round(PRN);
end

% table of C/A Code Tap Selection (sets delay for G2 generator)
tap=[2 6; 3 7; 4 8; 5 9; 1 9; 2 10; 1 8; 2 9; 3 10; 2 3; 3 4; 5 6; 6 7;...
 7 8; 8 9; 9 10; 1 4; 2 5; 3 6; 4 7; 5 8; 6 9; 1 3; 4 6; 5 7; 6 8;...
 7 9; 8 10; 1 6; 2 7; 3 8; 4 9];

%initializations
n=10; % Number of register stages
L=2^n-1; % Length of PRN sequence

% G1 LFSR: x^10+x^3+1
s=[0 0 1 0 0 0 0 0 0 1]; % G1 Register taps

% G2j LFSR: x^10+x^9+x^8+x^6+x^3+x^2+1
t=[0 1 1 0 0 1 0 1 1 1]; % G2 Register possible taps

g1=ones(1,n); % init g1
q=ones(1,n); % init g2

%generate C/A code sequence
tapp=tap(PRN,:);
for step=1:L % for each bit
 g2(:,step)=mod(sum(q(tapp),2),2); % mod-2 sum tap points
 code(:,step)=mod(g1(n)+g2(:,step),2); % code bit value is mod-2
% of g1 and g2
 g1=[mod(sum(g1.*s),2) g1(1:n-1)]; % shift g1
 q=[mod(sum(q.*t),2) q(1:n-1)]; % shift g2
end

%temp=1; %debug brkpt1

% convert to gold code 
% Use numerical values +1 and ?1 to represent logical 0s and 1s, respectively
for step=1:L 
 if code(step)==1
 code(step)=-1;
 else
     if code(step)==0
 code(step)=1;
     
     end
 end
end

%temp=2; %debug brkpt2

code=code';
end