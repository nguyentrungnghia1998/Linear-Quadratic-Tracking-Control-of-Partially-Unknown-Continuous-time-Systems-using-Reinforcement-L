%% Simulation of novel actor-critic-identifier - Bhashin 2013
clear; close all; clc;
load data.mat
%% Time interval and simulation time
Step = 0.001;T_end = 0.05;
t = 0:Step:T_end;
N = 600;
%% Variable
K=cell(1,20);
P=cell(1,20);
O=cell(1,N);
%% Parameter
xm=cell2mat(x);
um=cell2mat(u);
yd=3;
Xm=[xm;yd*ones(1,50*N+1)];
gamma=0.1;
T=0.05;
Q=10;
R=1;
C1=[1 0 -1];
B1=[5;1;0];
%% Initial value
K{1}=[-5 -1 -0.5];
K{2}=[-3.5116 -0.5189 1.6804];
K{3}=[-3.4666 -0.7224 2.6772];
K{4}=[-3.5827 -0.8325 2.4654];
K{5}=[-3.5188 -0.7705 2.5652];
K{6}=[-3.5351 -0.7857 2.5442];
k=1;
%% Simulation
PSI=zeros(N,9);
PHI=zeros(N,1);
for i=1:N
    X_curr=Xm(:,50*i-49:50*i+1)';
    u_curr=um(:,50*i-49:50*i+1)';
    x_kron_x=zeros(51,9);
    for j=1:51
        x_kron_x(j,:)=kron(X_curr(j,:),X_curr(j,:));
    end
    A1=exp(-gamma*T)*x_kron_x(end,:);
    A2=x_kron_x(1,:);
    x_kron_u=zeros(51,9);
    for j=1:51
        x_kron_u(j,:)=kron(X_curr(j,:),(u_curr(j)'-K{k}*X_curr(j,:)')'*B1')+kron((u_curr(j)'-K{k}*X_curr(j,:)')'*B1',X_curr(j,:));
    end
    A3=1/2*x_kron_u(1,:)*Step;
    for j=2:50
        A3=A3+x_kron_u(j,:)*exp(-gamma*t(j))*Step;
    end
    A3=A3+1/2*x_kron_u(end,:)*exp(-gamma*t(end))*Step;
    A4=1/2*x_kron_x(1,:)*Step;
    for j=2:50
        A4=A4+x_kron_x(j,:)*exp(-gamma*t(j))*Step;
    end
    A4=A4+1/2*x_kron_x(end,:)*exp(-gamma*t(end))*Step;
    Qk=C1'*Q*C1+K{k}'*R*K{k};
    vecQk=reshape(Qk,[9 1]);
    Atong=A1-A2-A3;
    Btong=-A4*vecQk;
    PSI(i,:)=Atong;
    PHI(i)=Btong;
end