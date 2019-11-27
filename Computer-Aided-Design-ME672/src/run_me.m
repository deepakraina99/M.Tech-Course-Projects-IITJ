%DEEPAK RAINA (M15ME003)
%Triangulation of Soild Models and generation of STL File

%% STL File Head
clc;
clear;
fid = fopen('stl.txt','at');
fprintf(fid,'solid Part1\n');
fclose(fid);
NFF=0;
%% Input Points
Data = fileread('Points2.txt');
Data = strrep(Data, ',', '');
Data = strrep(Data, ';', ' ');
FID = fopen('Points1.txt', 'w');
fwrite(FID, Data, 'char');
fclose(FID);
N = textread('points1.txt');
[aa,bb]= size(N);
 pp = 1;
 while pp <= aa
     if pp==1
         ff = N(pp,1);
         %fprintf('number of faces = %d  \n', N(p,1))
         pp = pp+1;
     else
         cc = N(pp,1);
         %fprintf('face %d \n',N(p,1))
         pp = pp+1;
         ee = N(pp,1);
         %fprintf('number of edges on the face %d = %d \n',N(p-1,1),N(p,1));
         PPP = zeros(2*ee,3);
         for ii = 1:ee
             for jj = 1:3
                 PPP(ii,jj)= N(pp+ii,jj);
             end
         end
         for ii = ee+1:2*ee
             for jj = 1:3
                 PPP(ii,jj)= N(pp+ii-ee,jj+3);
             end
         end
         PPP = unique(PPP,'rows');
         
         nrml = cross(PPP(3,:)-PPP(2,:),PPP(4,:)-PPP(2,:));
         nrml = nrml/norm(nrml);
         RM = [null(nrml),nrml.'];
         if det(RM)<0 
             RM(:,1:2) = RM(:,2:-1:1); 
         end
         R_PPP = PPP*RM;
         pp = pp+ee+1;
X=R_PPP(:,1);
Y=R_PPP(:,2);
Z=R_PPP(:,3);
w=numel(X);
NPF=w;
PPP=0;

%% Finding Max Bound of given Points
MaxX=max(X);
MaxY=max(Y);
MinX=min(X);
MinY=min(Y);

%Plotting of Super Traingle
LV=MaxY-MinY;
LH=MaxX-MinX;
P1=[MinX-LV-4,MinY-6];
P2=[MaxX+2,MinY-6];
P3=[MaxX+2,MaxY+LH+4];
X(w+1)=P1(1,1);
Y(w+1)=P1(1,2);
X(w+2)=P2(1,1);
Y(w+2)=P2(1,2);
X(w+3)=P3(1,1);
Y(w+3)=P3(1,2);
NP=w+3;

%% Insertion of Points

%Inserting 1st Point in Super Triangle
T(:,:,1) = [P1(1) P1(2);P2(1) P2(2);P3(1) P3(2)];
T(:,:,2) = T(:,:,1)+[0 0;0 0;-T(3,1,1)+X(1) -T(3,2,1)+Y(1)];
T(:,:,3) = T(:,:,1)+[0 0;-T(2,1,1)+X(1) -T(2,2,1)+Y(1);0 0];
T(:,:,4) = T(:,:,1)+[-T(1,1,1)+X(1) -T(1,2,1)+Y(1);0 0;0 0];

%Insertion of Other Points
t=4;
k=0;
E1=[0 0];
NP1=NP-3;
for j=2:NP1
    for i=2:t
        %Solving equation of circumcircle
        A(:,:,:,i)=[2*T(1,1,i), 2*T(1,2,i), 1;2*T(2,1,i), 2*T(2,2,i), 1;2*T(3,1,i), 2*T(3,2,i), 1];       
        B(:,:,:,i)=[-(T(1,1,i))^2-((T(1,2,i))^2);-(T(2,1,i))^2-((T(2,2,i))^2);-(T(3,1,i))^2-((T(3,2,i))^2)];
        C(:,:,:,i)=A(:,:,:,i)\B(:,:,:,i);
        g(:,:,:,i)=C(1,1,1,i);
        f(:,:,:,i)=C(2,1,1,i);
        c(:,:,:,i)=C(3,1,1,i);
        %Radius of Circumcircle
        r(i)=sqrt(g(i)^2 + f(i)^2 - c(i));      
        xc(i)=-(g(i));
        yc(i)=-(f(i));
        %Location of New Point with respect to Circumcircle   
        d(i)=sqrt((Y(j)-yc(i))^2+(X(j)-xc(i))^2);    
        
            if d(i)<=r(i)
                index(i)=i;
                 Ttemp1=T(:,:,i);
                X=round(X,10);
                Y=round(Y,10);
                Ttemp1=round(Ttemp1,10);
                 for p=1:NP
                     if Ttemp1(1,1)==X(p)
                         if Ttemp1(1,2)==Y(p)
                        Ttemp2(1,1)=p;
                         end
                     end
                     if Ttemp1(2,1)==X(p)
                         if Ttemp1(2,2)==Y(p)
                        Ttemp2(1,2)=p;
                         end
                     end
                     
                     
                  if Ttemp1(3,1)==X(p)
                         if Ttemp1(3,2)==Y(p)
                        Ttemp2(1,3)=p;
                         end
                  end
                  
                 end
                 
                 % Edges of Triangle violating Delaunay Triangulation
                    TR = triangulation(Ttemp2,X,Y);
                    clc;
                    E(:,:,i) = edges(TR);
       
                    E1 = [E1;E(:,:,i)];
        elseif d(i)>r(i)
            end    
    end
    % Edges of All Triangles violating Delaunay Triangulation
     E1 = E1(any(E1,2),:);
     e=size(E1,1);
     E2=E1;
    % Deletion of Common Edges
     for g=1:e
        for d=1:e
            if E1(g,1)==E1(d,1) && E1(g,2)==E1(d,2) && g~=d 
                E2([g,d],:)=0;
            end
        end
     end
    E2( ~any(E2,2), : ) = [];
    
    %Number of Triangles violating Delaunay Triangulation
    p=index(index~=0);
    p_count=numel(p);      
    y=1;
    
    %Formation of New Triangles
    for n=1:p_count
        T(:,:,p(n))=[X(E2(y,1)) Y(E2(y,1));X(E2(y,2)) Y(E2(y,2));X(j) Y(j)];                       
        y=y+1;
    end
        T(:,:,t+1)=[X(E2(y,1)) Y(E2(y,1));X(E2(y,2)) Y(E2(y,2));X(j) Y(j)];
        T(:,:,t+2)=[X(E2(y+1,1)) Y(E2(y+1,1));X(E2(y+1,2)) Y(E2(y+1,2));X(j) Y(j)];
    t=t+2;
    y=0;
    index=0;
    E=[];
    E1=[0,0];
    E2=0;
    TR=0;
    e=0;
    T_temp=0;
    p=0;
    p_count=0;
    g=0;
    d=0;
end

%% Indices of Delaunay Triangles
for q=1:t
    for s=1:NP
        Ttemp3=T(:,:,q);
        Ttemp3=round(Ttemp3,10);
        if Ttemp3(1,1)==X(s) && Ttemp3(1,2)==Y(s)
            T_out(q,1)=s;
        elseif Ttemp3(2,1)==X(s) && Ttemp3(2,2)==Y(s)
            T_out(q,2)=s;
        elseif Ttemp3(3,1)==X(s) && Ttemp3(3,2)==Y(s)
            T_out(q,3)=s;
         end
    end
end

%% Plotting of Delaunay Triangulation

scrsz = get(groot,'ScreenSize');
figure1=figure('Name','Delaunay Triangulation Window','NumberTitle','off','Position',[scrsz(1)*50 scrsz(2)*50 scrsz(1)*1250 scrsz(1)*600]);
axis square;

%Subplot 1 With Super Triangle
%subplot1 = subplot(1,2,1,'Parent',figure1);
%hold('all');
%triplot(T_out,X,Y,'Parent',subplot1)
%xlabel('x')
%ylabel('y')

%Deletion of Super Triangle
T_out(any(T_out==w+1,2),:) = [];
T_out(any(T_out==w+2,2),:) = [];
T_out(any(T_out==w+3,2),:) = [];


%% Generation of Results
%Number of Edges
%TR = triangulation(T_out,X,Y);
clc;
%FN = faceNormal(TR);
%E = edges(TR);
%NE=size(E,1);
%Number of Faces
NF=size(T_out,1);


% MATLAB Command Window Output
%d=['#Points = ',num2str(NPF),' #faces = ',num2str(NF),' #edges = ',num2str(NE)];
%disp(d)
%P=[x1,y1];
%P= cat(2,P,zeros(size(P,1),1));                     %(Ref: http://in.mathworks.com/matlabcentral/answers/20177-insert-zero-column-in-a-mxn-matrix)
%disp('coord1   coord2   coord3')
%disp(P)
%disp('facepoint1#  facepoint2# facepoint3#')
%disp(T_out)

% Results in .OFF File
%H = 'OFF';
%fid = fopen('outputDT.off', 'wt');                  %(Ref: http://in.mathworks.com/matlabcentral/newsreader/view_thread/52269)
%fprintf(fid, '%s\n',H);
%fclose(fid);
%Line1=[NPF NE NF];
%dlmwrite('outputDT.off',Line1,'-append','delimiter',' ','roffset',1)
%dlmwrite('outputDT.off',P,'-append','delimiter',' ','roffset',1)
%dlmwrite('outputDT.off',T_out,'-append','delimiter',' ','roffset',1)

%% Subplot 2 Without Super Triangle
subplot2 = subplot(1,2,2,'Parent',figure1);
%hold('all');
triplot(T_out,X,Y,'r','Parent',subplot2)
xlabel('x')
ylabel('y')

% %% STL File
% fid = fopen('stl.txt','at');
% NFF=NFF+NF;
% for st=1:NF
%     for v=1:3
%     xv(v)=X(T_out(st,v));
%     yv(v)=Y(T_out(st,v));
%     zv(v)=Z(T_out(st,v));
%     end
%     TM=[xv',yv',zv'];
%     Tnew=TM*(inv(RM));
%     Tnew=round(Tnew,5);
%     v1=Tnew(2,:)-Tnew(1,:);
%     v2=Tnew(3,:)-Tnew(1,:);
%     ntc=cross(v1,v2);
%     nt(st,:)=ntc/norm(ntc);
%     if st>1
%         if nt(st,1)~=nt(st-1,1)
%         TC1=Tnew(2,:);
%         TC2=Tnew(3,:);
%         Tnew(2,:)=TC2;
%         Tnew(3,:)=TC1;
%         Tnew=round(Tnew,5);
%         v1=Tnew(2,:)-Tnew(1,:);
%         v2=Tnew(3,:)-Tnew(1,:);
%         ntc=cross(v1,v2);
%         nt(st,:)=ntc/norm(ntc);
%         end
%         if nt(st,2)~=nt(st-1,2)
%         TC1=Tnew(2,:);
%         TC2=Tnew(3,:);
%         Tnew(2,:)=TC2;
%         Tnew(3,:)=TC1;
%         Tnew=round(Tnew,5);
%         v1=Tnew(2,:)-Tnew(1,:);
%         v2=Tnew(3,:)-Tnew(1,:);
%         ntc=cross(v1,v2);
%         nt(st,:)=ntc/norm(ntc);
%         end
%         if nt(st,3)~=nt(st-1,3)
%         TC1=Tnew(2,:);
%         TC2=Tnew(3,:);
%         Tnew(2,:)=TC2;
%         Tnew(3,:)=TC1;
%         Tnew=round(Tnew,5);
%         v1=Tnew(2,:)-Tnew(1,:);
%         v2=Tnew(3,:)-Tnew(1,:);
%         ntc=cross(v1,v2);
%         nt(st,:)=ntc/norm(ntc);
%         end
%     end
%     fprintf(fid,'   facet normal ' );
%     fprintf(fid,'%e %e %e\n',nt(st,1),nt(st,2),nt(st,3));
%     fprintf(fid,'      outer loop\n');
%     for vv=1:3
%     fprintf(fid,'         vertex ');
%     fprintf(fid,'%e %e %e\n',Tnew(vv,1),Tnew(vv,2),Tnew(vv,3));
%     end
%     fprintf(fid,'      endloop\n');
%     fprintf(fid,'   endfacet\n');
%     
% end
% 
% 

     end
     index=0;
    E=[];
    E1=[0,0];
    E2=0;
    TR=0;
    e=0;
    T_temp=0;
    p=0;
    p_count=0;
    g=0;
    d=0;
    T_out=0;
    RM=0;
    Ttemp3=0;
    
 end   
%fprintf(fid,'endsolid\n');
fclose(fid);

%% Triangles Message
s = dir('stl.txt');
filesize=s.bytes;
msgbox(sprintf('Triangles: %g\nFile Size: %g (Bytes)\nFile Format: ASCII',NFF,filesize),'Solidworks','warn')
pause(5)

%% Waitbar for STL file
h = waitbar(0,'Writing the .STL file. Please Wait.','Name','STL Writer');
steps = 3000;
for step = 1:steps
    waitbar(step / steps)
end
close(h)
[FileName,PathName] = uigetfile('*.txt','Select the .STL-file');
eval(['!notepad ' PathName FileName])

%% Waitbar for STL2 File
h = waitbar(0,'Paste the copied text of STL file into file to be opened and SAVE!','Name','SAVE STL FILE');
steps = 3000;
for step = 1:steps
    waitbar(step / steps)
end
close(h)
 [FileName,PathName] = uigetfile('Part1.STL');
 eval(['!notepad ' PathName FileName])
 
 %% Visualization in webpage
 h = waitbar(0,'The VISUALIZATION WINDOW will open now. Load the saved .STL file','Name','STL VIEW');
steps = 2500;
for step = 1:steps
    waitbar(step / steps)
end
close(h)
url=('http://www.viewstl.com/');
web(url,'-new','-notoolbar','-noaddressbox')

%%