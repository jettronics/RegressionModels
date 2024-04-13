clear all;

% Generate sample data
X = 10 * rand(100, 1);   % Independent variable
Y = 2*X + 3 + randn(100, 1);  % Dependent variable with added noise

% Predicted values using the regression line
m = 2;
b = 3;
Y_predicted = m*X + b;

% Plot the original data points
scatter(X, Y, 'k');
hold on;

% Plot the regression line
plot(X, Y_predicted, 'b', 'LineWidth', 1);

% Customize the plot
xlabel('Independent Variable (X)');
ylabel('Dependent Variable (Y)');
title('Linear Regression');
legend('Data Points', 'Regression Line', 'Location', 'north' );

% Turn off the hold
hold off;

