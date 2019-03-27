clearvars;
clear;
clear all;
close all;
clc;

Is = 0.01*10^-12;
Ib = 0.1*10^-12;
Vb = 1.3;
Gp = 0.1;

% Part 1
V= linspace(-1.95, 0.7, 200);
I = zeros(1,length(V));
for count = 1:length(V)
    I(count) = Is * (exp(1.2.*V(count)/0.025)-1) + Gp*V(count) - Ib*(exp(-1.2*(V(count)+Vb)/0.025)-1) ;
end
fa = rand(1,length(I))*0.4 -0.2;  
I2 = I.*(1-fa);

figure
plot(V,I)
xlabel('Voltage (Volts)')
ylabel('Current (A)')
title('Current without variation')

figure
plot(V,I2)
xlabel('Voltage (Volts)')
ylabel('Current (A)')
title('Current with 20% variation')

%Part 2
p = polyfit(V,I2, 4);
f = polyval(p,V);
figure
plot(V,f, 'r--');
xlabel('Voltage (Volts)')
ylabel('Current (A)')
title('Plot with 4th order polynomial fit')

p2 = polyfit(V,I2, 8);
f2 = polyval(p2,V);
figure
plot(V,f2, 'b*');
xlabel('Voltage (Volts)')
ylabel('Current (A)')
title('Plot with 8th order  polyfit')

%Part 3
%A
fo2 = fittype('A.*(exp(1.2*x/25e-3)-1)+0.1.*x-C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff2=fit(V',I2',fo2);
If2 = ff2(V');
figure
plot(V,If2);
xlabel('Voltage (Volts)')
ylabel('Current (A)')
title('Plot Fitting Fitting A and C')

%B
fo3 = fittype('A.*(exp(1.2*x/25e-3)-1)+B.*x-C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff3=fit(V',I2',fo3);
If3 = ff3(V);
figure
plot(V,If3);
xlabel('Voltage (Volts)')
ylabel('Current (A)')
title('Plot Fitting Fitting A, B and C')

%C
fo = fittype('A.*(exp(1.2*x/25e-3)-1)+B.*x-C*(exp(1.2*(-(x+D))/25e-3)-1)');
ff=fit(V',I2',fo);
If = ff(V);
figure
plot(V,If);
xlabel('Voltage (Volts)')
ylabel('Current (A)')
title('Plot Fitting Fitting A, B, C and D')

% Part 4
inputs = V;
targets = I2;
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn = outputs
figure

plot(Inn)
xlabel('Voltage (Volts)')
ylabel('Current (A)')
title('Fit using Neural Network')