clear all;

% Generate sample data
X = [1:1:100]';
Y = 0.25*X.^2 + 0.02*X + 200 + 200*randn(100,1);  % Dependent variable with added noise

% Predicted values using the regression line
a = 0.25;
b = 0.02;
c = 200;
Y_predicted = a*X.^2 + b.*X + c;

% Plot the original data points
scatter(X, Y, 'k');
hold on;

% Plot the regression line
plot(X, Y_predicted, 'b', 'LineWidth', 1);

% Customize the plot
xlabel('Independent Variable (X)');
ylabel('Dependent Variable (Y)');
title('Nonlinear Regression');
legend('Data Points', 'Regression Line', 'Location', 'north');

% Turn off the hold
hold off;
