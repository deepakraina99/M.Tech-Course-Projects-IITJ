%%%%... UR10 Forward Kinematics Code  ...%%%%
% written by Deepak Raina, TCS Robotics Lab Noida
clc; clear;

%%%%%..DH Parametres..%%%%%
%Joint angle (th) in degrees
% th=[0,0,0,0,0,0];
th=[-89.77,-110.88,-95.18,-65.16,-270.55,-0.70];
th=th*pi/180;
%link length (a)
a2=-0.612; a3=-0.5723;
%link offset (d)
d1=0.1273; d4=0.163941; d5=0.1157; d6=0.0922;
%link twist (alpha)
alpha1=pi/2; alpha4=pi/2; alpha5=-pi/2;

DHparameters =[ th(1),  d1,    0,  alpha1 ;
    th(2),   0,   a2,       0 ;
    th(3),   0,   a3,       0 ;
    th(4),  d4,    0,  alpha4 ;
    th(5),  d5,    0,  alpha5 ;
    th(6),  d6,    0,     0  ];

%Transformation Matrix
T = T_matrix_calc(DHparameters)

%Axis angle [Rx,Ry,Rz]
axisangle = Rot2axisAngles_myfunc(T(1:3,1:3))
axisangle = axisangle(1:3)*axisangle(4)
EulerAnglesZYX_myfunc = Rot2EulerAngles_myfunc(T(1:3,1:3))
quat_wxyz = rotm2quat(T(1:3,1:3))

%End-effector state
end_effector_state_xyz_RxRyRz = [T(1:3,4)'*1000,axisangle(1:3)]
