function [ scaled_value ] = scale_observation( observation, type )

if strncmp(type, 'a', 1)
    min = -180;
    max = 180;
elseif strncmp(type, 'd', 1)
    min = 0;
    max = 400;
else
    error(['Wrong type: ', type])
end

scaled_value = (observation - min) / (max - min);

end

