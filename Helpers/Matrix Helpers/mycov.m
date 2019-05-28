
function covar = mycov(data,means)
    covar = 1/(size(data,1)-1) * sum( (data(:,1)-means(1)) * (data(:,2)-means(2))');
end

