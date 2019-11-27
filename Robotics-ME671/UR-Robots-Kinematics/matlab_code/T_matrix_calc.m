%Function for calculating transformation matrix, gievn the DH parameters
function c = T_matrix_calc(DHparameters)
Th  = DHparameters(:,1);
d   = DHparameters(:,2);
a   = DHparameters(:,3);
alp = DHparameters(:,4);
n   = length(Th);
T   = eye(4);
c   = cell(1,n);
for i = 1 : length ( Th )
    A=[   cos( Th(i) ),   -sin( Th(i) ) * cos( alp(i) ),        sin( Th(i) ) * sin( alp(i) ),    a(i) * cos( Th(i) ) ;
        sin( Th(i) ),    cos( Th(i) ) * cos( alp(i) ),       -cos( Th(i) ) * sin( alp(i) ),    a(i) * sin( Th(i) ) ;
        0,                sin( alp(i) ),                    cos( alp(i) ),                d(i) ;
        0,                        0,                            0,                1 ] ;
    T = T * A;
    c = T;
end
end
