%Function for converting Rotation matrix to euler angles ZYX
function axisAngles = Rot2EulerAngles_myfunc(R)

r11 = R(1,1); r12 = R(1,2); r13=R(1,3);
r21 = R(2,1); r22 = R(2,2); r23=R(2,3);
r31 = R(3,1); r32 = R(3,2); r33=R(3,3);

beta = atan2(-r31,sqrt(r11^2 + r21^2));

alpha = atan2(r21/cos(beta),r11/cos(beta));

gamma = atan2(r32/cos(beta),r33/cos(beta));

if beta==pi/2
    beta = pi/2;
    alpha = 0;
    gamma = atan2(r12,r22);
end

if beta==-pi/2
    beta = -pi/2;
    alpha = 0;
    gamma = -atan2(r12,r22);
end

axisAngles = [alpha,beta,gamma];

