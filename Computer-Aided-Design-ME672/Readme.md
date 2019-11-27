

# Triangulation of Solid Models
The objective of this work is to triangulate a flat shaped solid model of SOLIDWORKS using Delaunay Triangulation and then generate a *.STL* file.
For more info, please refer this [presentation](https://github.com/deepakraina99/Triangulation-Solidworks-API_CAD/blob/master/src/Presentation.pdf)

> This work has been done as part of Computer Aided Design (CAM)
> course at IIT Jodhpur.

#### System Specs:
- Windows (32/64 bits)
- SOLIDWORKS 2014 x64
- MATLAB R2016a or higher
# How to run the code?
#### Steps:
**1.** Make the soild part in solidworks.

**2.** Load the macro *Macroprojtxtexe.swp* and run it. This will give the vertices in .txt file

**3.** The MATLAB code will then run automatically and perform triangulation on the given points. 
 
**4.** The *.stl* file will be generated in the end which can be visualized in soildworks or any other stl viewer.