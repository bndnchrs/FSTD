function cnew = correctedge(unew)
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

% Top Correct
unew(3,:) = unew(3,:) + unew(2,:); 
unew(2,:) = 0; 

% Left Correct
unew(:,3) = unew(:,3) + unew(:,2); 
unew(:,2) = 0; 


% Right Correct
unew(:,end-2) = unew(:,end-2) + unew(:,end-1); 
unew(:,end-1) = 0; 

% Bottom Correct
unew(end-2,:) = unew(end-2,:) + unew(end-1,:); 
unew(end-1,:) = 0; 

cnew = unew(3:end-2,3:end-2); 
end