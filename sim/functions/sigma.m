function Sigma = sigma(S)
        global Sbar elasticity
        Sigma = sqrt(max(0,Sbar^2 - elasticity.*(Sbar - S).^2));
end 