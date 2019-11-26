% Link Transformation Matrix using DH Parameters
function [ A ] = Homo_mat( a,b,c,d )
%   a is Joint angle theta
%   b is link offset d
%   c is link offset a
%   d is link twist alpha.

a1=[cos(a), -1*cos(d)*sin(a), sin(d)*sin(a), c*cos(a)];
a2=[sin(a), cos(d)*cos(a), -1*sin(d)*cos(a), c*sin(a)];
a3=[0, sin(d), cos(d), b];
a4=[0, 0, 0, 1];

A=[a1;a2;a3;a4];
end

