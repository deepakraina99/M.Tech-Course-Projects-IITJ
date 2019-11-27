he %%Vaibhav Gupta and Deepak Raina
%Adaptive Slicing Procedure for Layered Manufacturing

%% Input
clear;
clc;
%syms u
%x=a*cos(-pi+pi*u);
%y=b*sin(-pi+pi*u);
syms a b u p 
x = input('Enter equation of X in terms of a and parameter u : ');
y = input('Enter equation of Y in terms of b and parameter u : ');
a=input('Enter the value of a = ');
b=input('Enter the value of b = ');

%% Ellipse plot
scrsz = get(groot,'ScreenSize');
figure1=figure('Name','Layer Slicing Visualization in Rapid Prototyping','NumberTitle','off','Position',[scrsz(1)*100 scrsz(2)*50 scrsz(1)*1200 scrsz(1)*600]);
%subplot1 = subplot(1,2,1,'Parent',figure1);
%title('Uniform Layer Approximation','fontsize', 22)
hold('all');
u=0:.01:1;
x1 = subs(x);
y1 = subs(y);
%plot(x1,y1,'b','LineWidth',3,'Parent',subplot1);
hold on;
%syms u
%x=a*cos(-pi+pi*u);
%y=b*sin(-pi+pi*u);


fy= finverse(y);
fx= finverse(x);
display('---------------------------------------------------')
display('Machine Specification(STRATA-SYS)')
display('Minimum layer thickness 0.010 inch')
display('Maximum layer thickness 0.030 inch')
display('---------------------------------------------------')
l=input('Enter the layer thickness = ');

syms u
i = 1;
u =0.5;
ym=subs(y);
yold = 0;
xold = -a;
if l< 0.01 
    display('Infeasible Layer Thickness')
elseif l>0.03
    display('Infeasible Layer Thickness')
else
%% File Write
FID=fopen('gcode.txt','at');
time=clock;
material=115210;4
laycount=330;
fprintf(FID,';Time: %g-%g-%g %g:%g:%g\n;Material: %g\n;Layer Count: %g\n;Layer 0\nM107\n',time(3),time(2),time(1),time(4),time(5),time(6),material,laycount);
    
%% Input for Printing
display('---------------------------------------------------')
display('Enter Parameters of Printing')
display('---------------------------------------------------')
    partdepth = input('Enter Depth of Part (units) = ');
    NozzleDia = input('Enter Nozzle Diameter (units)= ');
    Flowrate  = input('Enter Infill Rate (unit/sec)= ');
    Travelrate = input ('Enter Travel Rate (unit/sec)= ');
    
%% Uniform Layer Approximation    
    ynew = -l;
   while yold > ym 
       u=ynew;
       u1=subs(fy);
       u=u1;
    %u = (pi + asin(ynew/b))/pi;
       xnew=subs(x);
       
    
    A = [xold, -xold];
    B = [yold, yold];
    %plot(A,B,'r','LineWidth',1.5,'Parent',subplot1);
    C = [xnew, xnew];
    D = [yold, ynew];
    E = [-xnew, -xnew];
    m = -xnew;
    m1 = double(m);
    if m1 > 0.0001
    diffx = xnew-xold;   
    theta = -atan(yold/xnew);
    delta = double(diffx*cos(theta));
    Cusp(i)= delta;
    Cusp1(i)=double(Cusp(i));
    i=i+1;    
    %plot(C,D,'r','LineWidth',1.5,'Parent',subplot1);
    %plot(E,D,'r','LineWidth',1.5,'Parent',subplot1);
    end
    xold = xnew;
    yold = ynew;
    ynew = ynew-l;
   end  
  
   Cusp1(i) = (yold+l)-ym;
end

maxcusp = max(Cusp1);


%% Result
%Cusp Height
display('-------------------------------------------------------------------')
fprintf('The calculated Cusp Height for the given part is %f units\n',maxcusp)
display('-------------------------------------------------------------------')

%% Adaptive Layer Approximation
j = 1;
u =0.5;
ym=subs(y);
xold = -a;
yold = 0;
%Coordx(j) = xold;
%Coordy(j) = yold;

i=1;
% Plot of Ellipse
subplot1 = subplot(1,2,1,'Parent',figure1);
title('Adaptive Layer Approximation','fontsize', 22)
hold('all');
plot(x1,y1,'b','LineWidth',3,'Parent',subplot1);
hold on
theta = 0;
k = 1;
time = 0;
kkk = 1;

while (theta < pi/2)  && (theta > -0.001)

k = xold ;   
syms p
k = p - maxcusp* sqrt(1+ (yold/p)^2);
fp = finverse(k);
p = xold;
xnew = double(subs(fp));
%jj = rem(i,2);
%if jj == 1
%Coordx(j) = xold;
%Coordx(j+1) = -xold;
%Coordy(j) = yold;
%Coordy(j+1) = yold;
%else
%Coordx(j) = -xold;
%Coordx(j+1) = xold;
%Coordy(j) = yold;
%Coordy(j+1) = yold;
%end
A = [xold, -xold];
B = [yold, yold];
 plot(A,B,'r','LineWidth',1.5,'Parent',subplot1);

xnew = xold + maxcusp/cos(theta);
u=xnew;
u2=double(subs(fx));
u = 2-u2;
ynew = double(subs(y));
layer(i) = ynew - yold;
if layer(i) > 0
    break
end
l = layer(i);
% Condition for maximum layer thickness
if l < -0.03
     l= 0.03;
     layer(i) = l;
     ynew = yold - layer(i);
     
     u=ynew;
     u2=double(subs(fy)); 
     u = 2-u2;
     xnew = double(subs(x));    
end

layerthik = abs(l);
layerwidth = pi*NozzleDia*NozzleDia*0.25*Flowrate/(Travelrate*layerthik);
iteration = round(partdepth/layerwidth);
ii = 0;

Coordz(kkk) = layerwidth;
Coordx(kkk) = -xold;
Coordy(kkk) = yold;
Coordz1 = Coordz(kkk);
fprintf(FID,'\nG0 %f %f %f\n',Coordx(kkk),Coordy(kkk),Coordz(kkk));
while ii< iteration
   
    kkk = kkk+1;
   
    Coordz(kkk) = Coordz1;
    Coordx(kkk) = -Coordx(kkk-1);
    Coordy(kkk) = yold;
    Coordz1 = Coordz(kkk);
    Coordz2 = Coordz(kkk) + layerwidth;
    fprintf(FID,'G1 %f %f %f\n',Coordx(kkk),Coordy(kkk),Coordz(kkk));
    if Coordz2 < partdepth
    %Coordz2 = Coordz1 + layerwidth;
    kkk = kkk+1;
    
    Coordz(kkk) = Coordz1 + layerwidth;
      
    Coordx(kkk) = Coordx(kkk-1);
    Coordy(kkk) = yold;
    Coordz1 = Coordz(kkk);
    %Coordz2 = Coordz1 + layerwidth;
    fprintf(FID,'G1 %f %f %f\n',Coordx(kkk),Coordy(kkk),Coordz(kkk));
    end
    ii=ii+1;
end    
kkk = kkk +1;

iterationdis = 2*abs(xnew)*iteration;
iterationtime = iterationdis/Travelrate;
time = time + iterationtime;
iterationremain = rem(partdepth,layerwidth);
Travelnewrate = pi*NozzleDia*NozzleDia*0.25*Flowrate/iterationremain*layerthik;
iterationtime = 2*abs(xnew)/Travelnewrate;
time = time + iterationtime;


C = [xnew, xnew];
D = [yold, ynew];
E = [-xnew, -xnew];

plot(C,D,'r','LineWidth',1.5,'Parent',subplot1);
plot(E,D,'r','LineWidth',1.5,'Parent',subplot1);




i= i+1;
j = j+2;
yold = ynew;
xold = xnew;
theta = atan(yold/xold);

end
A = [xold, -xold];
B = [yold, yold];
plot(A,B,'r','LineWidth',1.5,'Parent',subplot1);

subplot2 = subplot(1,2,2,'Parent',figure1);
title('Path Scanning','fontsize', 22);
plot3(Coordx,Coordy,Coordz,'Parent',subplot2,'LineWidth',1.1);
hold('all')
xlabel('x')
ylabel('y')
zlabel('z')

%%
fprintf('Total Number of Layers = %g\n',round(kkk/2))
fprintf('Total Printing Time = %g hrs\n',time/3600)
display('--------------------------------------------------------------')
gg=input('Press 1 for generating G-Code : ');
if gg==1
disp('------------------------------------------------------------------')
h = waitbar(0,'Writing the G-Code File. Please Wait.','Name','G-Code Writer');
steps = 3000;
for step = 1:steps
    waitbar(step / steps)
end
close(h)
[FileName,PathName] = uigetfile('*.txt','Select the gcode.txt-file');
eval(['!notepad ' PathName FileName])
end

%% End
display('----------------------------------------------------------------')
display('The G-code and Path Scanning is done.')
display('----------------------------------------------------------------')

%% End
