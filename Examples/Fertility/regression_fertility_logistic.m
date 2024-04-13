clear all;
pkg load signal;

R = dlmread("fertility_Diagnosis.csv",";");
L = 100;
x = zeros(9,L);
x(1,:) = R(:,1)'; %season: winter: -1, spring: -0.33, summer: 0.33, fall: 1 
x(2,:) = R(:,2)' * 8 + 18; %age: 18...36
x(3,:) = R(:,3)';%child diseases: yes: 0, no: 1
x(4,:) = R(:,4)';%trauma or accident: yes: 0, no: 1
x(5,:) = R(:,5)';%surgical: yes: 0, no: 1
x(6,:) = R(:,6)';%high fevers: less than three months ago: -1, more than three months ago: 0, no; 1
x(7,:) = R(:,7)';%alcohol: several times a day: 0.2, every day: 0.4, several times a week: 0.6, once a week: 0.8, hardly ever or never: 1
x(8,:) = R(:,8)';%smoking: never: -1, occasional: 0, daily: 1
x(9,:) = R(:,9)' * 16;%sitting: max 16h
y = R(:,10)';%diagnosis: normal: 1, otherwise: 0
%x1 = (0.5:0.25:5.25);
%x2 = (0.2:0.1:2.1);
%y = zeros(1,size(x1));

mean = zeros(1,9);
mean_s = zeros(1,9);
%Scaling needed for every feature vector befor merged into x
%Mean value = 0, standard deviation = 1
for i=1:9
   mean(i) = sum(x(i,:)/L);
   dev(i) = sqrt(sum((x(i,:)-mean(i)).^2)/L);
   x_s(i,:) = (x(i,:) - mean(i)) / dev(i);
   mean_s(i) = sum(x_s(i,:)/L);
   dev_s(i) = sqrt(sum((x_s(i,:)-mean_s(i)).^2)/L);
end

%theta
h = zeros(10,1);

X = zeros(L,10);

for i=1:L
   X(i,1) = 1;
   X(i,2) = x_s(1,i);
   X(i,3) = x_s(2,i);
   X(i,4) = x_s(3,i);
   X(i,5) = x_s(4,i);
   X(i,6) = x_s(5,i);
   X(i,7) = x_s(6,i);
   X(i,8) = x_s(7,i);
   X(i,9) = x_s(8,i);
   X(i,10) = x_s(9,i);   
end

beta = 0.0002;
lambda = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0;];
%lambda = [-0.5; -0.2;];

% Bayes estimation
for i=1:400
  H = 1 ./ (1 + exp(-(X * h)));
  h = h - beta * ((X' * H) - (X' * y') + (lambda * h' * h ));
end

% Regression result
Y_r = 1 ./ (1 + exp(-(X * h)));

p = zeros(1,9);
p(1) = -1; %season: winter: -1, spring: -0.33, summer: 0.33, fall: 1 
p(2) = 36; %age: 18...36
p(3) = 0; %child diseases: yes: 0, no: 1
p(4) = 1; %trauma or accident: yes: 0, no: 1
p(5) = 1; %surgical: yes: 0, no: 1
p(6) = 1; %high fevers: less than three months ago: -1, more than three months ago: 0, no; 1
p(7) = 1; %alcohol: several times a day: 0.2, every day: 0.4, several times a week: 0.6, once a week: 0.8, hardly ever or never: 1
p(8) = -1; %smoking: never: -1, occasional: 0, daily: 1
p(9) = 4; %sitting: max 16h

p_s(1) = 1;
for i=2:10
   p_s(i) = (p(i-1) - mean(i-1)) / dev(i-1);
end

Y_p = p_s * h;
Y_p = min(Y_p,1);
Y_p = max(Y_p,0);

figure(1)
clf
subplot(3,1,1)
plot(x_s(1,:),y,'ok')
%plot(x_s(1,:),y,'ok')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on
subplot(3,1,2)
plot(x_s(2,:),y,'ok')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on
subplot(3,1,3)
plot(x_s(3,:),y,'ok')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on

figure(2)
subplot(3,1,1)
plot(x(4,:),y,'ok')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on
subplot(3,1,2)
plot(x(5,:),y,'ok')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on
subplot(3,1,3)
plot(x(6,:),y,'ok')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on

figure(3)
subplot(3,1,1)
plot(x(7,:),y,'ok')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on
subplot(3,1,2)
plot(x(8,:),y,'ok')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on
subplot(3,1,3)
plot(x(9,:),y,'ok')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on
%{
figure(2)
clf
subplot(2,1,1)
%plot(x1,Y_r,'k')
plot((x_s1 * dev1) + mean1,Y_r,'k')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on
subplot(2,1,2)
%plot(x2,Y_r,'k')
plot((x_s2 * dev2) + mean2,Y_r,'k')
%axis([0 0.2 0 1.2])
%ylabel('Input signal')
%xlabel('Time in s','fontweight','normal','FontName','Arial', 'FontSize',10)
%title('Input signal','fontweight','normal','FontName','Arial', 'FontSize',12)
grid on
%}