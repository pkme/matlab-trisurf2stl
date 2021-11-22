# trimodel2stl
Export the model represented by triangular surface built in Matlab to STL file.

## Usage

Copy trisurf2stl.m to your program directory.



```matlab
trisurf2stl(filename,k,v)
% Export the model represented by triangular surface built in Matlab to STL file.
%
%   filename is the STL file to be saved.
%   k is a three-column matrix where each row represents a triangular facet. The values represent the row indices of the input points.
%   v is a three-column matrix. v= [X,Y,Z]
%
%   This program is rewritten from surf2stl of Bill McDonald.
%
%   Author: Weidong Shen 2021/11/22
```









