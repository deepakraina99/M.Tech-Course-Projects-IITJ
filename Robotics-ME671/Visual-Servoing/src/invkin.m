% Inverse Kinematics 2-link robot
function [th]=invkin(Oc,a)
x=Oc(1); y=Oc(2); a1=a(1); a2=a(2);
%Joint Angles
%Theta 2
c2=(x^2 + y^2 - a1^2 - a2^2)/(2*a1*a2);
s2=sqrt(1 - c2^2);
th2=atan2(s2, c2);

%Theta 1
k1=a1 + a2*c2;
k2=a2*s2;
th1=atan2(y, x)-atan2(k2, k1);

th=[th1; th2];


