%%%##### Visual Servoing of 2-link robot #########%%%
clc; clear;
display('----------------------------------------')
display('Visual Servoing of 2-link robot')
display('----------------------------------------')

%Point location
P=[1; 0; 1];
lam=0.5; %Focal length
dt=0.0001; %time step
K=200; %Gain value
delta=0.05; %Acceptable error
a=[1; 1]; %Link length

% Image coordinates
Oci=[1,1,0]; %Initial Camera location
[thi]=invkin(Oci,a); %Initial Joint angles
pci=cam(thi,a,P); % Initial location of point wrt to camera frame
%Initial image cordinates
x=pci(1); y=pci(2); z=pci(3);
u=lam*x/z; v=lam*y/z;
s=[u; v];

Ocf=[1; 0; 0]; %Final Camera location
[thf]=invkin(Ocf,a); %Final Joint angles
pcf=cam(thf,a,P);%Final location of point wrt to camera frame
%Final image cordinates
xd=pcf(1); yd=pcf(2); zd=pcf(3);
ud=lam*xd/zd; vd=lam*yd/zd;
sd=[ud; vd];

%Error
e=s-sd;
en=norm(e);
i=1;
pc=pci;
th=thi;
time(i)=0;
theta(i,:)=th';
image(i,:)=s';
err(i)=en;
while en > delta
    x=pc(1); y=pc(2); z=pc(3);
    u=lam*x/z; v=lam*y/z;
    s=[u; v];
    L=[-lam/z    0    v
        0     -lam/z -u];
    Jc=[a(1)*sin(th(2))    0
        a(1)*cos(th(2))+a(2) a(2)
        1          1];
    Lm=L*Jc;
    e=s-sd;
    en=norm(e);
    dth=-K*(pinv(Lm))*e;
    th=th+dth*dt;
    pc=cam(th,a,P);
    i=i+1;
    theta(i,:)=th';
    dtheta(i,:)=dth';
    time(i)=time(i-1)+dt;
    image(i,:)=s';
    err(i)=en;
end

%Animation
display('Animating simulation data')
display('----------------------------------------')
display('time (s)')
animation(time,theta,a,image,sd);

%Plot Error in image coordinates
display('----------------------------------------')
display('Plotting error in image coordinates')
display('----------------------------------------')
error_im(time,err)
%Plot Joint Velocities
display('Plotting rate of joint angles')
display('----------------------------------------')
display('Contributor: Deepak Raina (M.Tech, IIT J)')
display('----------------------------------------')
joint_vel(time,dtheta)



