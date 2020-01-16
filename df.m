function PTDF = df(bus,branch)
%df calculates distribution factors using line Bij only
%   Detailed explanation goes here

%%% It should handle parallel lines OK but they to show up as 
%%% separate lines 
Ar = busIncMat(bus,branch);
nl = size(Ar, 2);
diagB = sparse([1:nl],[1:nl],1.0./(branch(:,4)),nl,nl);
%%%%
%Rupa Edit - 07/23/2018
refbus = 1;
temp = (Ar*diagB*Ar');
% temp2 = inv(temp);
temp(refbus,:) = zeros(1,size(temp,1));
temp(:,refbus) = zeros(size(temp,1),1);
temp(refbus,refbus) = 1;
temp1 = inv(temp);
temp1(refbus,refbus) = 0;
PTDF = diagB*Ar'*temp1;
end

