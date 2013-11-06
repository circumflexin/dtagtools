function da = dynacc(tag,Aw)
%calculate dynamic acceleration from matrix of tag acceleration data
%Aw is the input acceleration data from prh file
if nargin<2 | ~exist('Aw','var')
    loadprh(tag,'Aw');
end
da = (-1+sqrt(Aw(:,1).^2 + Aw(:,2).^2 + Aw(:,3).^2)).*9.8;
da = abs(da - mean(da));
