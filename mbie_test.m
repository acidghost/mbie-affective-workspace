time_steps = 1:10;
current_obs_w = ones(3, 2);
current_obs_w(1, 1) = scale_observation(0, 'a');
current_obs_w(2, 1) = scale_observation(0, 'a');
current_obs_w(3, 1) = scale_observation(0, 'a');

current_obs_w

for i = time_steps;
    posture = (current_obs_w(:, 1)' * current_obs_w(:, 2)) / sum(current_obs_w(:, 2));
    mood = tanh(posture * i);
    
    disp(['Timestep ', num2str(i), ' p=', num2str(posture), ' m=', num2str(mood)])
end
