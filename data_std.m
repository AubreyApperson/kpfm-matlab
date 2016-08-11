function [dataA, stdA] = data_std(A, square,limited_len, pointAx, pointAy)
%DATA_STD Works in conjunction with test2 to gather data, find st. dev. and
%perform avg on points from kpfm endgame DOS
%   Detailed explanation goes here

%% Create array for data from pointA
dataA = zeros(1,limited_len); 
% Create array for st. dev from pointA
stdA = zeros(1,limited_len);

% Average a square of points with PointA in the upper left
points = zeros(1,square*square); % create an array to hold the points per image that will be averaged.
for i = 1:limited_len  %iterate through all the images
    l = 1; % start a counter for the array of averages
    for j = 0:square-1
        for k = 0:square-1
            points(l) = A(pointAx+j, pointAy+k, i);
            l = l+1;
        end
    end
    dataA(i) = sum(points);
    dataA(i) = dataA(i)/(square*square);
    stdA(i) = std(points); 
end
end

