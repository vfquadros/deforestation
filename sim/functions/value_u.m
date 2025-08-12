function Vu = value_u(A,R,F) 

    global alpha beta Tlag wage pi 
    term1 = alpha .* A .* (1 - beta^Tlag) ./ (1 - beta);
    term2 = beta^Tlag * (pi .* (R+wage/(1-beta)) + (1 - pi) .* ...
        (A + beta * pi .* (R + wage / (1 - beta))) ./ (1 - beta * (1 - pi)));
    Vu = term1 - F + term2;
end
