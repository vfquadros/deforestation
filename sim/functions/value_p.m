function Vp = value_p(A,F)
        global beta Tlag alpha 
        Vp = ((1 - beta^Tlag) * alpha + beta^Tlag) .* A / (1 - beta) - F;
end