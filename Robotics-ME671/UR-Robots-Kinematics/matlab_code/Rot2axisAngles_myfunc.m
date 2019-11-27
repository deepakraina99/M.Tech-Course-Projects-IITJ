%Function for converting Rotation matrix to axis angles Rx Ry Rz
function axang =  Rot2axisAngles_myfunc(R)
theta=acos((trace(R)-1)/2);
vec = [0 0 0];
axang=[0 0 0 0];
vec(1)=R(3,2)-R(2,3);
vec(2)=R(1,3)-R(3,1);
vec(3)=R(2,1)-R(1,2);
vec=(1/(2*sin(theta)))*vec;
axang = [vec, theta];
end