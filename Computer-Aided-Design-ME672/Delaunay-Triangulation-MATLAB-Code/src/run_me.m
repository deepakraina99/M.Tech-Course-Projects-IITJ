%DEEPAK RAINA (M15ME003)

%Delauney Triangulations

%Input Points
NP=xlsread('Points.xls','Sheet1','D2');
Coor=xlsread('Points.xls','Sheet1','B4:D1000');
for j=1:NP
    i=Coor(j,1);
    X(i)=Coor(j,2);
    Y(i)=Coor(j,3);
end

%Finding Max Bound of given Points
MaxX=max(X);
MaxY=max(Y);
MinX=min(X);
MinY=min(Y);

%Plotting of Super Traingle
LV=MaxY-MinY;
LH=MaxX-MinX;
P1=[MinX-LV-4,MinY-2];
P2=[MaxX+2,MinY-2];
P3=[MaxX+2,MaxY+LH+4];

%Inserting 1st Point in Super Triangle
T(:,:,1) = [P1(1) P1(2);P2(1) P2(2);P3(1) P3(2)];
T(:,:,2) = T(:,:,1)+[0 0;0 0;-T(3,1,1)+X(1) -T(3,2,1)+Y(1)];
T(:,:,3) = T(:,:,1)+[0 0;-T(2,1,1)+X(1) -T(2,2,1)+Y(1);0 0];
T(:,:,4) = T(:,:,1)+[-T(1,1,1)+X(1) -T(1,2,1)+Y(1);0 0;0 0];

%Addition of Other Points
t=4;
k=0;
for j=2:NP
    for i=2:t
        A(:,:,:,i)=[2*T(1,1,i), 2*T(1,2,i), 1;2*T(2,1,i), 2*T(2,2,i), 1;2*T(3,1,i), 2*T(3,2,i), 1];       %Solving equation of circumcircle
        B(:,:,:,i)=[-(T(1,1,i))^2-((T(1,2,i))^2);-(T(2,1,i))^2-((T(2,2,i))^2);-(T(3,1,i))^2-((T(3,2,i))^2)];
        C(:,:,:,i)=A(:,:,:,i)\B(:,:,:,i);
        g(:,:,:,i)=C(1,1,1,i);
        f(:,:,:,i)=C(2,1,1,i);
        c(:,:,:,i)=C(3,1,1,i);
        r(i)=sqrt(g(i)^2 + f(i)^2 - c(i));       %Radius of Circumcircle
        xc(i)=-(g(i));
        yc(i)=-(f(i));
        d(i)=sqrt((Y(j)-yc(i))^2+(X(j)-xc(i))^2);    %Location of New Point with respect to Circumcircle   
       
            if d(i)<r(i)
                index(i)=i;
                k=k+3;
                I(k-2)=T(1,1,i);
                I(k-1)=T(2,1,i);
                I(k)=T(3,1,i);
                J(k-2)=T(1,2,i);
                J(k-1)=T(2,2,i);
                J(k)=T(3,2,i);
                H=[transpose(I),transpose(J)];
                H1=unique(H,'rows');              %Boundary Ponts of Disturbed Triangle by New Point
                K=H1(:,1);
                L=H1(:,2);
                I_mean=mean(K);
                J_mean=mean(L);
                angles = atan2((L-J_mean),(K-I_mean));            %Anti-clockwise Orientation of Boundary Points
                [sortedAngles, sortIndices] = sort(angles);       %(Ref: http://in.mathworks.com/matlabcentral/answers/121856-how-to-draw-polygon-having-set-of-unordered-points)
                I_new = K(sortIndices);                                    
                J_new = L(sortIndices);                                    
            
        elseif d(i)>=r(i)
            end    
    end
    s=size(I_new,1);
    p=index(index~=0);
    p_count=numel(p);      %p_count=Number of Triangles affected due to addition of each point
    y=1;
    
    %New Triangles formed
    for n=1:p_count
        T(:,:,p(n))=[I_new(y,1) J_new(y,1);I_new(y+1,1) J_new(y+1,1);X(j) Y(j)];                       
        y=y+1;
    end
        T(:,:,t+1)=[I_new(y,1) J_new(y,1);I_new(y+1,1) J_new(y+1,1);X(j) Y(j)];
        T(:,:,t+2)=[I_new(y+1,1) J_new(y+1,1);I_new(1,1) J_new(1,1);X(j) Y(j)];
    t=t+2;
    k=0;
    y=0;
    index=0;
    I=0;
    J=0;
    K=0;
    L=0;
    H=0;
    H1=0;
    angles=0;
    s=0;
    p_count=0;
    sortedAngles=0;
    sortIndices=0;
end

%Forming Triangle Matrix with indexed coordinates 
T_out=zeros(t,3);
for q=1:t
    for s=1:NP
        if T(1,1,q)==X(s) && T(1,2,q)==Y(s)
            T_out(q,1)=s;
        elseif T(2,1,q)==X(s) && T(2,2,q)==Y(s)
            T_out(q,2)=s;
        elseif T(3,1,q)==X(s) && T(3,2,q)==Y(s)
            T_out(q,3)=s;
         end
    end
end

%Deletion of Super Triangle
T_out(any(T_out==0,2),:) = [];   %(Ref: http://in.mathworks.com/matlabcentral/answers/40018-delete-zeros-rows-and-columns)

%Generation of Results
X_t=transpose(X);
Y_t=transpose(Y);
TR = triangulation(T_out,X_t,Y_t);
E = edges(TR);
NE=size(E,1);           %Number of Edges (Ref:http://in.mathworks.com/matlabcentral/answers/20499-count-rows-in-matrix)
NF=size(T_out,1);                   %Number of Faces(Triangles)

%MATLAB Command Window Output
d=['#Points = ',num2str(NP),' #faces = ',num2str(NF),' #edges = ',num2str(NE)];
disp(d)
P=[X_t,Y_t];
P= cat(2,P,zeros(size(P,1),1));                     %(Ref: http://in.mathworks.com/matlabcentral/answers/20177-insert-zero-column-in-a-mxn-matrix)
disp('coord1   coord2   coord3')
disp(P)
disp('facepoint1#  facepoint2# facepoint3#')
disp(T_out)

%Results in .OFF File
H = 'OFF';
fid = fopen('outputDT.off', 'wt');                  %(Ref: http://in.mathworks.com/matlabcentral/newsreader/view_thread/52269)
fprintf(fid, '%s\n',H);
fclose(fid);
Line1=[NP NE NF];
dlmwrite('outputDT.off',Line1,'-append','delimiter',' ','roffset',1)
dlmwrite('outputDT.off',P,'-append','delimiter',' ','roffset',1)
dlmwrite('outputDT.off',T_out,'-append','delimiter',' ','roffset',1)

%Plotting of Delaunay Triangulation
triplot(T_out,X,Y)
hold on




