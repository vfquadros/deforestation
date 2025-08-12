function B = b(A,S,k)
   global pI rho Sbar elasticity
   B = pI .* (rho - 1) .* (A(1,k) .* sigma(S) ./ (rho .* pI)).^(rho ./ (rho - 1));
end

