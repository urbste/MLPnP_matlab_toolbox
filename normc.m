function xx = normc(x)
    row = size(x, 1);
    col = size(x, 2);
    xx = zeros(row, col);
    for i = 1 : col
        xx(:, i) = x(:, i) / norm(x(:, i));
    end
end
