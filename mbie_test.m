time_steps = 1:10;
current_obs_w(1, 1:2) = [scale_observation(0, 'a') 1/3];
current_obs_w(2, 1:2) = [scale_observation(0, 'a') 1/3];
current_obs_w(3, 1:2) = [scale_observation(0, 'a') 1/3];

current_obs_w

for i = time_steps;
    posture = (current_obs_w(:, 1)' * current_obs_w(:, 2)) / sum(current_obs_w(:, 2));
    if i == 1
        mood = tanh(posture * i);
        old_mood = mood;
    else
        old_mood = mood;
        mood = tanh(posture * i);
    end
    
    disp(['Timestep ', num2str(i), ' p=', num2str(posture), ' m=', num2str(mood)])
end
