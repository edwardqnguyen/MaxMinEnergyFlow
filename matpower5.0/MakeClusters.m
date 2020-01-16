%Interconnected
load('Jopen.mat','Jopen')
A1 = Jopen;
ind1 = 1:35;
ind2 = 36:38;
ind3 = 39:73;
ind4 = 74:76;

Load = numel(ind1); Gen = numel(ind2);

J11 = A1(ind1,ind1); J12 = A1(ind1,ind2); J13 = A1(ind1,ind3); J14 = A1(ind1,ind4);
J21 = A1(ind2,ind1); J22 = A1(ind2,ind2); J23 = A1(ind2,ind3); J24 = A1(ind2,ind4);
J31 = A1(ind3,ind1); J32 = A1(ind3,ind2); J33 = A1(ind3,ind3); J34 = A1(ind3,ind4);
J41 = A1(ind4,ind1); J42 = A1(ind4,ind2); J43 = A1(ind4,ind3); J44 = A1(ind4,ind4);
% J = [J11 J12 J13 J14;
%     J21 J22 23 J24;
%     J31 J32 33 J34;
%     J41 J42 43 J44];
% 
% J1 = [J11 J12 J13
%     J21 J22 23
%     J31 J32 33];
% 
% J1 = J1 - [J14;J24;J34]*((J44)^-1)*[J41 J42 43];
%Scenario 1
A = [J11 J12 J13;%zeros(numel(ind1),numel(ind3));
    J21  J22 J23;
    J31  J32 J33];

B = [J14  zeros(numel(ind1),Gen);
    J24  -ones(numel(ind2),Gen);
    J34  zeros(numel(ind3),Gen)];

% C = [zeros(Load,numel(ind1)) zeros(Load,numel(ind2)) ones(Load,numel(ind3))];
%PV and Critical load voltages
y1 = [32     3    25     8    15    19    34];%    36];
% y1 = [32     1     2     3     4     5     6    23    24    25    26    27     8    15    19    34];
%All load voltages
% y1 = 1:1:35;
 C = zeros(numel(y1), numel(ind1)+numel(ind2)+numel(ind3));

for k = 1:numel(y1)
    
C(k,numel(ind1) + numel(ind2) + y1(k)) = 1;

end
   
MatScenario1 = C*(-A\B);

%%
%Isolated
% clear A1 J11 J12 13 J14 J21 J22 23 J24
% clear J31 J32 33 J34 J41 J42 43 J44
% load('Jclose.mat','Jclose')
% A1 = Jclose;
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
% 
% y1 =  [33     4    26     9    16    20    35];
% % y1 = [1     2     3    37     4     5     6     7    24    25    26    27    28];
% % y2 = [33 ]
% % y1 = [33     2     3     4     5     6     7    24    25    26    27    28     9    16    20    35];
% %All load voltages
% % y1 = 1:1:35;
% C = zeros(numel(y1), numel(ind1)+numel(ind2)+numel(ind3));
% 
% for k = 1:numel(y1)
% C(k,numel(ind1) + numel(ind2) + y1(k)) = 1;
% end
% 
% MatScenario2 = C*(-A\B);
% 
% %%
% %Fully Isolated (GridFollow)
% clear A1 J11 J12 13 J14 J21 J22 23 J24
% clear J31 J32 33 J34 J41 J42 43 J44
% load('JFollow.mat','JFollow')
% A1 = JFollow;
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
% y1 =  [ 33     4    26     9    16    20    35]; 
% % y1 = [33     2     3     4     5     6     7    24    25    26    27    28     9    16    20    35];
% %All load voltages
% % y1 = 1:1:35;
% C = zeros(numel(y1), numel(ind1)+numel(ind2)+numel(ind3));
% 
% for k = 1:numel(y1)
% C(k,numel(ind1) + numel(ind2) + y1(k)) = 1;
% end
% 
% MatScenario3 = C*(-A\B);
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
% y1 =  [ 33     4    26     9    16    20    35]; 
% % y1 = [33     2     3     4     5     6     7    24    25    26    27    28     9    16    20    35];
% %All load voltages
% % y1 = 1:1:35;
% C = zeros(numel(y1), numel(ind1)+numel(ind2)+numel(ind3));
% 
% for k = 1:numel(y1)
% C(k,numel(ind1) + numel(ind2) + y1(k)) = 1;
% end
% 
% MatScenario4 = C*(-A\B);
% 
