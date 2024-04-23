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
%x1 = (0.5:0.25:5.25);
%x2 = (0.2:0.1:2.1);
%y = zeros(1,size(x1));

mean = zeros(1,V);
mean_s = zeros(1,V);
%Scaling needed for every feature vector befor merged into x
%Mean value = 0, standard deviation = 1
for i=1:V
   mean(i) = sum(x(i,:)/L);
   dev(i) = sqrt(sum((x(i,:)-mean(i)).^2)/L);
   x_s(i,:) = (x(i,:) - mean(i)) / dev(i);
   mean_s(i) = sum(x_s(i,:)/L);
   dev_s(i) = sqrt(sum((x_s(i,:)-mean_s(i)).^2)/L);
end

%theta
h = zeros(V+1,1);

X = zeros(L,V+1);

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

beta = 0.00002;
lambda = [0.0001; 0.00001; 0.00001; 0.00001; 0.00001; 0.00001; 0.00001; 0.00001; 0.00001; 0.00001; 0.00001; 0.00001; 0.00001;];
%lambda = [0.0; 0.0; 0.0;];

% Bayes estimation
for i=1:1500
  h = h - beta * ((X' * X * h) - (X' * y') + (lambda * h' * h ));
end

% Regression result
Y_r = X * h;


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
p(10) = 4; %parking: number of parking lots
p(11) = 0; %prefarea: house located in preferred area: no: 0, yes: 1
p(12) = 1; %furnishingstatus: furnished: 2, semi-furnished: 1, unfurnished: 0

p_s(1) = 1;
for i=2:V+1
   p_s(i) = (p(i-1) - mean(i-1)) / dev(i-1);
end

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