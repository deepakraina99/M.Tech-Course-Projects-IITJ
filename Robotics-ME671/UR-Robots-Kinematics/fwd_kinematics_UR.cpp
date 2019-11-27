/*********************************************************************
                   Kinematics of Universal Robot
 *********************************************************************

/* Author: Deepak Raina, TCS Robotics Lab*/

#include <iostream>
#include <math.h>
#include <vector>
#include <opencv/cv.h>

using namespace std;
using namespace cv;

#define DEG2RAD(x) M_PI*x/180
#define RAD2DEG(x) 180*x/M_PI

//Function to calculate transform from base to ee_link. Input will be current joint angles (th)
//and identity matrix (homoTransform).
void calculateTransform(double th[], cv::Mat &homoTransform){

    //*******DH-Parameters of UR10*******//
    //link length (a)
    double a[6]={0,-0.612,-0.5723,0,0,0};
    //joint offset (d)
    double d[6]={0.1273,0,0,0.163941,0.1157,0.0922};
    //link twist (alpha)
    double alp[6]={M_PI/2,0,0,M_PI/2,-M_PI/2,0};

    //    double DH[6][4]={{th[0],d[0],a[0],alp[0]},
    //                     {th[1],d[1],a[1],alp[1]},
    //                     {th[2],d[2],a[2],alp[2]},
    //                     {th[3],d[3],a[3],alp[3]},
    //                     {th[4],d[4],a[4],alp[4]},
    //                     {th[5],d[5],a[5],alp[5]}};

    Mat T = Mat::eye(4, 4, CV_64F);

    for (int i=0; i<6; i++)
    {
        T.at<double>(0,0)= cos(th[i]);
        T.at<double>(0,1)=-sin(th[i])*cos(alp[i]);
        T.at<double>(0,2)=sin(th[i])*sin(alp[i]);
        T.at<double>(0,3)=a[i]*cos(th[i]);

        T.at<double>(1,0)= sin(th[i]);
        T.at<double>(1,1)=cos(th[i])*cos(alp[i]);
        T.at<double>(1,2)=-cos(th[i])*sin(alp[i]);
        T.at<double>(1,3)=a[i]*sin(th[i]);

        T.at<double>(2,0)= 0;
        T.at<double>(2,1)=sin(alp[i]);
        T.at<double>(2,2)=cos(alp[i]);
        T.at<double>(2,3)=d[i];

        T.at<double>(3,0)=0;
        T.at<double>(3,1)=0;
        T.at<double>(3,2)=0;
        T.at<double>(3,3)=1;

        homoTransform = homoTransform*T;
    }
//    cout << "Transform base_to_ee_link = " << endl << homoTransform << endl;
}

//Function for converting rotation matrix to axis angles
void Rotm2axisAngles(cv::Mat homoTransform, double axang[]){
    Mat R = Mat(3, 3, CV_64F, 0.0);
    R = homoTransform.colRange(0,3).rowRange(0,3);
    Scalar trcR = trace(R);
    //cout << trcR(0) << endl;
    double theta=acos((trcR(0)-1)/2);
    double vec[3]={0,0,0};
    vec[0]=(R.at<double>(2,1)-R.at<double>(1,2))*(1/(2*sin(theta)));
    vec[1]=(R.at<double>(0,2)-R.at<double>(2,0))*(1/(2*sin(theta)));
    vec[2]=(R.at<double>(1,0)-R.at<double>(0,1))*(1/(2*sin(theta)));
    axang[0]=vec[0]*theta; axang[1]=vec[1]*theta; axang[2]=vec[2]*theta;
//    cout << axang[0] << "\t" << axang[1] <<  "\t" << axang[2] << endl;
}

int main(){

    //calculating transformation matrix
    double th[6]={DEG2RAD(-89.77),DEG2RAD(-110.88),DEG2RAD(-95.18),DEG2RAD(-65.16),DEG2RAD(-270.55),DEG2RAD(-0.70)};
    //double th[6]={DEG2RAD(-94.44),DEG2RAD(-66.50),DEG2RAD(-104.83),DEG2RAD(-89.90),DEG2RAD(-268.15),DEG2RAD(-2.19)};
    Mat homoTransform = Mat::eye(4, 4, CV_64F);
    calculateTransform(th,homoTransform);

    //finding axis angle from rotation matrix
    double axang[3]={0,0,0};
    Rotm2axisAngles(homoTransform,axang);

    //end_effector state
    double ee_x, ee_y, ee_z, ee_Rx, ee_Ry, ee_Rz;
    ee_x=homoTransform.at<double>(0,3);
    ee_y=homoTransform.at<double>(1,3);
    ee_z=homoTransform.at<double>(2,3);
    ee_Rx=axang[0];
    ee_Ry=axang[1];
    ee_Rz=axang[2];

    cout << "----------------------------------------------" << endl;
    cout << "End-effector State:\n"
            << "X(m) = " << ee_x << "\n"
            << "Y(m) = " << ee_y << "\n"
            << "Z(m) = " << ee_z << "\n"
            << "Rx(rad) = " << ee_Rx << "\n"
            << "Ry(rad) = " << ee_Ry << "\n"
            << "Rz(rad) = " << ee_Rz << endl;
    cout << "----------------------------------------------" << endl;




}

