%% Simulation of novel actor-critic-identifier - Bhashin 2013
clear; close all; clc;
%% Time interval and simulation time
Step = 0.001;T_end = 30;
t = 0:Step:T_end;
%% Variable
x=cell(1,size(t,2));
u=cell(1,size(t,2));
%% Parameter
A=[0.5 1.5;2 -2];
B=[5;1];
C=[1 0];
Q=10;
R=1;
yd=3;
K=[-5 -1 -0.5];
wi=normrnd(0,50,[100 1]);
%% Initial value
x{1}=[-2;1];
%% Simulation
for i=1:size(t,2)
    u{i}=K*[x{i};yd]+nhieu(t(i),wi,100);
    if i==size(t,2)
        break
    end
    %% Update state
    x{i+1}=x{i}+Step*(A*x{i}+B*u{i});
end

xm=cell2mat(x);
plot(t,xm(1,:))

function e=nhieu(t,wi,n)
e=0;
for i=1:n
    e=e+0.1*sin(wi(i)*t);
end
end