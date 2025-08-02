function M = RiemannianMean(tC)
% Computing the Riemannian mean using the algorithm proposed in
% https://www.sciencedirect.com/science/article/abs/pii/S0925231213001574
% https://github.com/amitaybar/Interference-Rejection-using-Riemannian-Geometry-for-DoA-Estimation
    Np = size(tC, 3);
    M  = mean(tC, 3);

    % h = waitbar(0, 'Riemannian Mean');
    for ii = 1 : 20
    %     waitbar(ii / 20);
        A = M ^ (1/2);      %-- A = C^(1/2)
        B = A ^ (-1);       %-- B = C^(-1/2)

        S = zeros(size(M));
        for jj = 1 : Np
            C = tC(:,:,jj);
            S = S + A * logm(B * C * B) * A;
        end
        S = S / Np;

        M = A * expm(B * S * B) * A; 

        eps = norm(S, 'fro');
        if (eps < 1e-6)
            break;
        end
    end
    % close(h);

end
