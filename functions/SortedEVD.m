function [EigvecMat, EigValVec] = SortedEVD(Mat)
% Get the eigenvalues and the associated eigenvectors, according to
% descending order of the eigenvalues
% https://github.com/amitaybar/Interference-Rejection-using-Riemannian-Geometry-for-DoA-Estimation
    [Phi, LambdaMat]    = eig(Mat);
    [~, ind]             = sort(diag(LambdaMat), 'desc');
    LambdaMat           = LambdaMat(ind, ind);
    EigvecMat        	= Phi(:, ind);
    EigValVec           = diag(LambdaMat);
end