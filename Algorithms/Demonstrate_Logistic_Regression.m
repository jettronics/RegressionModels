clear all;

% Generate sample data
X = [1:1:100]';
Y = 10./(1+exp(-0.2*(X-50))) + 2*randn(100,1);  % Dependent variable with added noise

% Predicted values using the regression line
Y_predicted = 10./(1+exp(-0.2*(X-50)));

% Plot the original data points
scatter(X, Y, 'k');
hold on;

% Plot the regression line
plot(X, Y_predicted, 'b', 'LineWidth', 1);

% Customize the plot
xlabel('Independent Variable (X)');
ylabel('Dependent Variable (Y)');
title('Logistic Regression');
legend('Data Points', 'Regression Line', 'Location', 'north');

% Turn off the hold
hold off;
