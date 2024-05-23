clear all;
pkg load signal;

R = dlmread("framingham_heart_disease.csv",";");
L = 3656;
V = 15;
x = zeros(15,L);
x(1,:) = R(:,1)'; %male: 1, female: 0
x(2,:) = R(:,2)'; %age
x(3,:) = R(:,3)'; %education: 1…no graduation, 2...secondary school certificate, 
                            % 3…secondary school diploma, 4…high school
x(4,:) = R(:,4)'; %current smoker
x(5,:) = R(:,5)'; %cigarettes per day
x(6,:) = R(:,6)'; %blood presure medication 
x(7,:) = R(:,7)'; %prevalent stroke 
x(8,:) = R(:,8)'; %prevalent hypertensive
x(9,:) = R(:,9)'; %diabetes
x(10,:) = R(:,10)'; %total cholesterol: >240…Dangerous, 200…239 At risk, <200 Heart healthy
x(11,:) = R(:,11)'; %systolic blood pressure
x(12,:) = R(:,12)'; %diastolic blood pressure
x(13,:) = R(:,13)'; %BMI
x(14,:) = R(:,14)'; %heart rate
x(15,:) = R(:,15)'; %glucose level: >110 pathological, 60…109 normal
y = R(:,16)'; %ten years risk of heart disease

mean = zeros(1,V);
mean_s = zeros(1,V);
x_s = zeros(V+1,L);

%Scaling needed for every feature vector
%Mean value = 0, standard deviation = 1
for i=1:V
   mean(i) = sum(x(i,:)/L);
   dev(i) = sqrt(sum((x(i,:)-mean(i)).^2)/L);
   x_s(i+1,:) = (x(i,:) - mean(i)) / dev(i);
   mean_s(i) = sum(x_s(i+1,:)/L);
   dev_s(i) = sqrt(sum((x_s(i+1,:)-mean_s(i)).^2)/L);
end

h = zeros(V+1,1);
h_b = zeros(V+1,1);
X = zeros(L,V+1);

%{   
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
   X(i,11) = x_s(10,i);
   X(i,12) = x_s(11,i);
   X(i,13) = x_s(12,i);
end
%}

it = 300;
beta = 0.0002;

x_s(1,:) = 1;
X = x_s';

% Bayesian Regression activated
lambda = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0;];

h_trend = zeros(V+1,it);
for i=1:it
  H = 1 ./ (1 + exp(-(X * h)));
  h = h - beta * ((X' * H) - (X' * y') + (lambda * h' * h ));
  h_trend(:,i) = h;
end

% Bayesian Regression activated
lambda_b = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0;];

for i=1:it
  H_b = 1 ./ (1 + exp(-(X * h)));
  h_b = h_b - beta * ((X' * H_b) - (X' * y') + (lambda * h_b' * h_b ));
end

% Default Regression result
Y_r = 1 ./ (1 + exp(-(X * h)));

% Bayesian Regression result
Y_rb = 1 ./ (1 + exp(-(X * h_b)));


p = zeros(1,V);
p(1) = 0; %male: 1, female: 0
p(2) = 65; %age
p(3) = 4; %education: 1…no graduation, 2...secondary school certificate, 
                            % 3…secondary school diploma, 4…high school
p(4) = 1; %current smoker
p(5) = 10; %cigarettes per day
p(6) = 1; %blood presure medication 
p(7) = 1; %prevalent stroke 
p(8) = 1; %prevalent hypertensive
p(9) = 1; %diabetes
p(10) = 200; %total cholesterol: >240…Dangerous, 200…239 At risk, <200 Heart healthy
p(11) = 170; %systolic blood pressure
p(12) = 110; %diastolic blood pressure
p(13) = 70; %BMI
p(14) = 90; %heart rate
p(15) = 150; %glucose level: >110 pathological, 60…109 normal

p_s(1) = 1;
for i=2:V+1
   p_s(i) = (p(i-1) - mean(i-1)) / dev(i-1);
end

% Regression sample result
Y_p = 1 ./ (1 + exp(-(p_s * h)));
%Y_p = min(Y_p,1);


figure(1)
clf
z = 1:V;
colours = { 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b' };
hold on
for i = 2 : V+1
  H(i-1) = bar( z(i-1), h(i), 0.4, 'facecolor', colours{i} );
endfor
grid on
xlim([0 16])
labels = ['Male'; 'Age'; 'Education'; 'Smoker'; 'Cigarettes'; 'BP Med.'; 'Stroke'; 'Hypertensive'; 'Diabetes'; 'Tot. Chol.'; 'Sys. BP'; 'Dia. BP'; 'BMI'; 'HR'; 'Glucose'];
set(gca, 'xtick', z, 'xticklabel', labels); 

figure(2)
clf
plot(h_trend(3,:))
hold on
plot(h_trend(11,:))
hold on
plot(h_trend(14,:))
hold on
plot(h_trend(16,:))
hold on
grid on
%ylim([0 100])
xlabel('Iterations')
legend('Age', 'Total Cholesterol','BMI','Glucose Level')

%{
set(gca,'xtick',[])

figure(3)
clf
subplot(3,1,1)
plot(x_s(11,:),y,'ok')
hold on
grid on
axis("tick[y]");
ylim([0 170000])
title('Parking lots impact on Price - Original')
subplot(3,1,2)
plot(X(:,11),Y_r,'ok')
hold on
grid on
axis("tick[y]");
ylim([0 170000])
title('Parking lots impact on Price - Default Regression')
subplot(3,1,3)
plot(X(:,11),Y_rb,'ok')
hold on
grid on
axis("tick[y]");
ylim([0 170000])
title('Parking lots impact on Price - Bayesian Regression')
%}

