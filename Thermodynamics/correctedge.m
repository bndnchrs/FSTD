function [cnew,lossl,lossu] = correctedge(unew,flagxcorr,flagycorr)
%% Correct for Corners

% Left Top Corner
unew(3,3) = unew(3,3) + unew(2,2);
unew(2,2) = 0;


% Right Top Corner
unew(3,end-2) = unew(3,end-2) + unew(2,end-1);
unew(2,end-1) = 0;


% Right Bottom Corner
unew(end-2,end-2) = unew(end-2,end-2) + unew(end-1,end-1);
unew(end-1,end-1) = 0;

% Left BottomCorner
unew(end-2,3) = unew(end-2,3) + unew(end-1,2);
unew(end-1,2) = 0;


%% Correct at sides

% Top Correct. Corresponds to advection out to the low end in size
if ~flagxcorr
unew(3,:) = unew(3,:) + unew(2,:);
unew(2,:) = 0;
end
%%
% Left Correct Corresponds to advection out to the low end in thickness

if ~flagycorr
    unew(:,3) = unew(:,3) + unew(:,2);
    unew(:,2) = 0;
end
%%
% Right Correct Corresponds to advection out the high end in thickness. Not
% allowed
unew(:,end-2) = unew(:,end-2) + unew(:,end-1);
unew(:,end-1) = 0;

% Bottom Correct Corresponds to advection out the high end in size. Not allowed
unew(end-2,:) = unew(end-2,:) + unew(end-1,:);
unew(end-1,:) = 0;

cnew = unew(3:end-2,3:end-2);
lossl = unew(2,3:end-2);
lossu = unew(3:end-2,2);
end