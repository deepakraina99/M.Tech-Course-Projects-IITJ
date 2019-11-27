
# Adaptive Slicing Procedure for Layered Manufacturing
For controlling the accuracy of the model and for reducing the staircase effect, Adaptive slicing needs to be performed. In this procedure, the user can specify a maximum allowable cusp height for the object. Then, the layer thicknesses are computed based on the surface geometry and the prescribed cusp height. The basic principle of adaptive slicing is to evaluate local surface geometries to determine the build layer thickness that can be used while maintaining a user-defined surface tolerance, usually measured by the cusp height
For more info, please refer this [presentation](https://github.com/deepakraina99/ALS-GCodes-Generation_CAM/blob/master/src/Presentation_ALS.pdf)

> This work has been done as part of Computer Aided Manufacturing (CAM)
> course at IIT Jodhpur.

#### System Specs:
- Windows/Ubuntu OS (32/64 bits)
- MATLAB R2016a or higher
# How to run the code?
#### Steps:
**1.** Run the *run_me.m* file.

**2.** Enter the parametric equation of curvature. eg. for ellipse, *x=a.cos(theta), y=b.cos(theta)*

**3.** Specify the minimum and maximum layer thickness depending upon the capabilities of the rapid prototyping machine.

**4.** The MATLAB Program will perform adaptive layer slicing on a given curvature.

**5.** The G-code file as *gcode.txt* will be generated in the end that can be fed to the machine for printing the part.