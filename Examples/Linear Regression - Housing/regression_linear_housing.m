clear all;
pkg load signal;

R = dlmread("Housing.csv",";");
L = 545;
V = 12;
x = zeros(12,L);
x(1,:) = R(:,2)' * 0.092903; %area: square feet to qm
x(2,:) = R(:,3)'; %bedrooms
x(3,:) = R(:,4)'; %bathrooms
x(4,:) = R(:,5)'; %stories: number of levels
x(5,:) = R(:,6)'; %main road: house faces main road
x(6,:) = R(:,7)'; %guestroom: no: 0, yes: 1
x(7,:) = R(:,8)'; %basement: no: 0, yes: 1
x(8,:) = R(:,9)'; %hotwaterheating: house uses gas: no: 0, yes: 1
x(9,:) = R(:,10)'; %airconditioning: no: 0, yes: 1
x(10,:) = R(:,11)'; %parking: number of parking lots
x(11,:) = R(:,12)'; %prefarea: house located in preferred area: no: 0, yes: 1
x(12,:) = R(:,13)'; %furnishingstatus: furnished: 2, semi-furnished: 1, unfurnished: 0
y = R(:,1)' * 0.011; %price: indian rupie to euro

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

it = 200;
beta = 0.0002;

x_s(1,:) = 1;
X = x_s';

% Bayesian Regression activated
lambda = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; -0.002; 0.0; 0.0;];

for i=1:it
  h = h - beta * ((X' * X * h) - (X' * y') + (lambda * h' * h ));
end

% Bayesian Regression activated
lambda_b = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; -0.002; 0.0; 0.0;];

for i=1:it
  h_b = h_b - beta * ((X' * X * h_b) - (X' * y') + (lambda_b * h_b' * h_b ));
end


h_trend = zeros(V+1,it);
%{
for i=1:it
  h = h - beta * ((X' * X * h) - (X' * y') + (lambda * h' * h ));
  h_trend(:,i) = h;
end
%}

% Default Regression result
Y_r = X * h;

% Bayesian Regression result
Y_rb = X * h_b;


p = zeros(1,V);
p(1) = 300; %area: qm
p(2) = 2; %bedrooms
p(3) = 2; %bathrooms
p(4) = 2; %stories: number of levels
p(5) = 0; %main road: house faces main road
p(6) = 2; %guestroom: no: 0, yes: 1
p(7) = 1; %basement: no: 0, yes: 1
p(8) = 1; %hotwaterheating: house uses gas: no: 0, yes: 1
p(9) = 0; %airconditioning: no: 0, yes: 1
p(10) = 3; %parking: number of parking lots
p(11) = 0; %prefarea: house located in preferred area: no: 0, yes: 1
p(12) = 1; %furnishingstatus: furnished: 2, semi-furnished: 1, unfurnished: 0

p_s(1) = 1;
for i=2:V+1
   p_s(i) = (p(i-1) - mean(i-1)) / dev(i-1);
end

% Regression sample result
Y_p = p_s * h;

%Y_p = min(Y_p,1);


figure(1)
clf
z = 1:V+1;
%colours = { 'm', 'm', 'm', 'm', 'b', 'm', 'm', 'm', 'm' };
hold on
for i = 1 : V+1
  %H(i) = bar( z(i), h(i), 0.4, 'facecolor', colours{i} );
  H(i) = bar( z(i), h(i), 0.4 );
endfor
grid on

figure(2)
clf
plot(h_trend(2,:))
hold on
plot(h_trend(3,:))
hold on
plot(h_trend(4,:))
hold on
plot(h_trend(5,:))
hold on
grid on
ylim([0 8000])
xlabel('Iterations')
legend('Area in qm', 'Number of bedrooms','Number of bathrooms','Number of stories')

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

