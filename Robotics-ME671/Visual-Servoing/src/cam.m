% location of point wrt to camera frame    
function [pc]=cam(th,a,P)
    th1=th(1); th2=th(2); a1=a(1); a2=a(2);
    %DH Parameters
    DH=[th1, 0, a1, 0; th2, 0, a2, 0];
    %Transformation Matrix
    for i=1:2
        A=Homo_mat(DH(i,1), DH(i,2), DH(i,3), DH(i,4));
        if (i~=1)
            T(:,:,i)=T(:,:,i-1)*A;
        else
            T(:,:,1)=A;
        end
    end
    R=T(1:3,1:3,2);
    O=T(1:3,4,2);
    pc=R'*(P-O);