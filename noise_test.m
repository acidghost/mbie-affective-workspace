clear; clf

x = 0:pi/100:8*pi;
samples = length(x);
alpha = .1;
data = zeros(samples, 2);
data_with_noise = zeros(samples, 2);
data_filtered = zeros(samples, 2);
errors_filtered = zeros(samples, 1);
errors_unfiltered = zeros(samples, 1);
for i = 1:samples;
    xi= x(i);
    yi = sin(xi);
    data(i, :) = [xi yi];
    noisyi = yi+normrnd(0, .2);
    data_with_noise(i, :) = [xi noisyi];
    if i == 1
        data_filtered(i, :) = [xi noisyi];
    else
        data_filtered(i, :) = [xi data_filtered(i-1, 2) + alpha * (noisyi - data_filtered(i-1, 2))];
    end
    errors_filtered(i) = (data_filtered(i, 2) - data(i, 2))^2;
    errors_unfiltered(i) = (data_with_noise(i, 2) - data(i, 2))^2;
end

rmse_filtered = sqrt(mean(errors_filtered));
disp(['RMSE filtered: ', num2str(rmse_filtered)])
rmse_unfiltered = sqrt(mean(errors_unfiltered));
disp(['RMSE unfiltered: ', num2str(rmse_unfiltered)])

subplot(1,3,1)
plot(data(:,1), data(:,2))
subplot(1,3,2)
plot(data_with_noise(:,1), data_with_noise(:,2))
subplot(1,3,3)
plot(data_filtered(:,1), data_filtered(:,2))