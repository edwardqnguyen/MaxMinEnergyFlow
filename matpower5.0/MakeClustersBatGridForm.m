%%
%Isolated
clear A1 J11 J12 13 J14 J21 J22 23 J24
clear J31 J32 33 J34 J41 J42 43 J44
load('Jclose.mat','Jclose')
A1 = Jclose;
% load('JFullIso.mat','JFullIso')
% A1 = JFullIso;
ind1 = 1:36;
ind2 = 37:38;
ind3 = 39:74;
ind4 = 75:76;

BatIndP = 10; ind4Part = 75; BatInd = 10;
Load = numel(ind1); Gen = numel(ind2);

J11 = A1(ind1,ind1); J12 = A1(ind1,ind2); J13 = A1(ind1,ind3); J14 = A1(ind1,ind4Part);
J21 = A1(ind2,ind1); J22 = A1(ind2,ind2); J23 = A1(ind2,ind3); J24 = A1(ind2,ind4Part);
J31 = A1(ind3,ind1); J32 = A1(ind3,ind2); J33 = A1(ind3,ind3); J34 = A1(ind3,ind4Part);
J41 = A1(ind4,ind1); J42 = A1(ind4,ind2); J43 = A1(ind4,ind3); J44 = A1(ind4,ind4);

temp1 = J11(:,BatInd);
J11(:,BatInd) = []; 

temp2 = J21(:,BatInd);
J21(:,BatInd) = []; 

temp3 = J31(:,BatInd);
J31(:,BatInd) = []; 

J31(BatInd,:) = []; J32(BatInd,:) = []; J33(BatInd,:) = [];
J34(BatInd,:) = []; temp3(BatInd,:) = []; 

%Scenario 1
A = [J11 J12 J13;%zeros(numel(ind1),numel(ind3));
    J21  J22 J23;
    J31  J32 J33];

Bpart1 = zeros(numel(ind1),1);
Bpart1(BatIndP,1) = -1;

B = [J14  Bpart1 temp1;
    J24  zeros(numel(ind2),1) temp2;
    J34  zeros(numel(ind3)-1,1) temp3];

% C = [zeros(Load,numel(ind1)) zeros(Load,numel(ind2)) ones(Load,numel(ind3))];
%PV and Critical load voltages

% y1 =  [33     4    26     9    16    20    35];
y1 = [ 2     3     4     5     6     7    24    25    26    27    28    33     9    16    20    35];
% y1 = [33     2     3     4     5     6     7    24    25    26    27    28     9    16    20    35];
%All load voltages
% y1 = 1:1:35;
C = zeros(numel(y1), numel(ind1)+numel(ind2)+numel(ind3)-1);

for k = 1:numel(y1)
C(k,numel(ind1) + numel(ind2) + y1(k)) = 1;
end

MatScenario2 = C*(A\B);

%%
% %Fully Isolated (GridFollow)
% clear A1 J11 J12 13 J14 J21 J22 23 J24
% clear J31 J32 33 J34 J41 J42 43 J44
% load('JFullIso.mat','JFullIso')
% A1 = JFullIso;
% ind1 = 1:36;
% ind2 = 37:38;
% ind3 = 39:74;
% ind4 = 75:76;
% 
% Load = numel(ind1); Gen = numel(ind2);
% 
% J11 = A1(ind1,ind1); J12 = A1(ind1,ind2); J13 = A1(ind1,ind3); J14 = A1(ind1,ind4);
% J21 = A1(ind2,ind1); J22 = A1(ind2,ind2); J23 = A1(ind2,ind3); J24 = A1(ind2,ind4);
% J31 = A1(ind3,ind1); J32 = A1(ind3,ind2); J33 = A1(ind3,ind3); J34 = A1(ind3,ind4);
% J41 = A1(ind4,ind1); J42 = A1(ind4,ind2); J43 = A1(ind4,ind3); J44 = A1(ind4,ind4);
% 
% %Scenario 1
% A = [J11 J12 J13;%zeros(numel(ind1),numel(ind3));
%     J21  J22 J23;
%     J31  J32 J33];
% 
% B = [J14  zeros(numel(ind1),Gen);
%     J24  -ones(numel(ind2),Gen);
%     J34  zeros(numel(ind3),Gen)];
% 
% % C = [zeros(Load,numel(ind1)) zeros(Load,numel(ind2)) ones(Load,numel(ind3))];
% %PV and Critical load voltages
% % y1 =  [ 33     4    26     9    16    20    35]; 
% y1 = [2     3     4     5     6     7    24    25    26    27    28    33     9    16    20    35];
% %All load voltages
% % y1 = 1:1:35;
% C = zeros(numel(y1), numel(ind1)+numel(ind2)+numel(ind3));
% 
% for k = 1:numel(y1)
% C(k,numel(ind1) + numel(ind2) + y1(k)) = 1;
% end
% 
% MatScenario3 = C*(A\B);
% 
% %%
% %Fully Isolated (GridForm)
% clear A1 J11 J12 13 J14 J21 J22 23 J24
% clear J31 J32 33 J34 J41 J42 43 J44
% load('JForm.mat','JForm')
% A1 = JForm;
% ind1 = 1:36;
% ind2 = 37:38;
% ind3 = 39:74;
% ind4 = 75:76;
% 
% Load = numel(ind1); Gen = numel(ind2);
% 
% J11 = A1(ind1,ind1); J12 = A1(ind1,ind2); J13 = A1(ind1,ind3); J14 = A1(ind1,ind4);
% J21 = A1(ind2,ind1); J22 = A1(ind2,ind2); J23 = A1(ind2,ind3); J24 = A1(ind2,ind4);
% J31 = A1(ind3,ind1); J32 = A1(ind3,ind2); J33 = A1(ind3,ind3); J34 = A1(ind3,ind4);
% J41 = A1(ind4,ind1); J42 = A1(ind4,ind2); J43 = A1(ind4,ind3); J44 = A1(ind4,ind4);
% 
% %Scenario 1
% A = [J11 J12 J13;%zeros(numel(ind1),numel(ind3));
%     J21  J22 J23;
%     J31  J32 J33];
% 
% B = [J14  zeros(numel(ind1),Gen);
%     J24  -ones(numel(ind2),Gen);
%     J34  zeros(numel(ind3),Gen)];
% 
% % C = [zeros(Load,numel(ind1)) zeros(Load,numel(ind2)) ones(Load,numel(ind3))];
% %PV and Critical load voltages
% % y1 =  [ 33     4    26     9    16    20    35]; 
% y1 = [33     2     3     4     5     6     7    24    25    26    27    28     9    16    20    35];
% %All load voltages
% % y1 = 1:1:35;
% C = zeros(numel(y1), numel(ind1)+numel(ind2)+numel(ind3));
% 
% for k = 1:numel(y1)
% C(k,numel(ind1) + numel(ind2) + y1(k)) = 1;
% end
% 
% MatScenario4 = C*(A\B);
% 
