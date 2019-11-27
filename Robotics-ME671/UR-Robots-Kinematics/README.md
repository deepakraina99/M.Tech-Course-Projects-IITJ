# Forward Kinematics of Universal Robots

This code can be used to calculate the end-effector state of universal robot, given the current joint angles (i.e. forward kinematics). The pose of end-effector calculated from this code can be directly send to the ur-driver using 'movel' or 'movej' commands in URSript. The code is avialbale in both C++ and Matlab.

### Information of functions used
  - calculateTransform: Function to calculate transform from base to ee_link. Input will be current joint angles and identity matrix of dimension 4x4.
  - Rotm2axisAngles: Function for converting rotation matrix to axis angles Rx, Ry and Rz. Input to this function will be 4x4 transformation matrix.

## Authors

* **Deepak Raina**
