function [Cpout, Pos] = my_deCasteljau(Cp,lambda)          
% Cpout are the control points of two curves.
% i.e.    cptsPA = Cpout(:, 1:length(Cp(1,:)));
%         cptsPB = Cpout(:, length(Cp(1,:)):end);
% Pos is the position at lambda
% lambda must be in [0,1]

[n,m] = size(Cp);
n = n-1;

A = (1-lambda)*eye(n,n);
B = lambda*eye(n,n);
C = zeros(n+1,n);

C(1:n,:) = C(1:n,:) + A; 
C(2:n+1,:) = C(2:n+1,:) + B;

Cptemp = Cp;
Cp1 = zeros(n,m);
Cp2 = zeros(n,m);

for i = n:-1:1
    Cptemp(1:i,:) = (C(1:i+1,1:i).')*Cptemp(1:i+1,:);
    Cp1(n+1-i,:) = Cptemp(1,:);
    Cp2(i,:) = Cptemp(i,:);
end

Cpout = [Cp(1,:); Cp1];
Cpout(:,:,2) = [Cp2; Cp(end,:)];
Pos = Cp1(end,:);

end