
# **Visual Servoing**
Visual servoing, also known as vision-based robot control and abbreviated VS, is a technique which uses feedback information extracted from a _vision_ sensor (_visual_ feedback) to control the motion of a robot. This code will design an image-based visual servoing controller for the 2-link robotic system.
> This work has been done as part of Robotics course at IIT Jodhpur.
#### System Specs:
- Windows/Ubuntu OS (32/64 bits)
- MATLAB R2016a or higher
# How to run the code?
#### Steps:
**1.** Run *_visual_servo.m_* file to run the program.

**2.** *_invkin.m_* file gives joint angles of robot for given end-effector (or camera) position

**3.** *_cam.m_* gives position of given point with respect to camera frame.

**4.** *_Homo_mat.m_* function generates the transformation matrix for the robot, given its joint angles and link lengths.

**5.** *_animation.m_* function shows the figure showing animation of 2-link robot. It also shows image of the camera.

**6.** *_erro_im.m_* function plots the error in image coordinates.

**7.** *_joint_vel.m_* function plots the joint velocities of 2-link robot.