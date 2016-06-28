==================================
Please run the following files in matlab (recommended version: R2008a)

(1) main_ordinary_3d.m
% The experiment in the ordinary 3D case.
% noise level 3 pixels.
% number of points n= 4 ... 20
% The methods compared are DLT, EPnP, EPnP_GN, LHM and RPnP.
% Details can be found in the paper.


(2) main_quasi_singular.m
% The experiment in the quasi-singular case.
% noise level 3 pixels.
% number of points n= 4 ... 20
% The methods compared are DLT, EPnP, EPnP_GN, LHM and RPnP.


(3) main_planar.m
% The experiment in the planar case.
% noise level 3 pixels.
% number of points n= 4 ... 20
% The methods compared are HOMO, LHM, SP and RPnP.
% The EPnP code for planar target is not involved, because it has not been publicly released.


(4) main_selecting_axis.m
% The experiment on the influence of the rotation axis selection step.
% The rotation axis is selected in different ways:
% RPnP1: randomly select an edge
% RPnP*: finding the longest in all n(n-1)/2 edges
% RPnP : the default setting which randomly semples n edge and selects the longest


(5) main_time.m
% The experiment which tests the computational time.
% LHM, EPnP, EPnP_GN and RPnP are tested.


(6) main_4pt.m
% The experiment in the ordinary 3D case.
% noise level 0.5 ... 5 pixels.
% number of points n= 4
% The methods compared are DLT, EPnP, EPnP_GN, LHM and RPnP.


(7) main_5pt.m
% The experiment in the ordinary 3D case.
% noise level 0.5 ... 5 pixels.
% number of points n= 5
% The methods compared are DLT, EPnP, EPnP_GN, LHM and RPnP.


=================================
The method list:

(1) ./func/RPnP.m
% The RPnP algorithm by C. Xu
% function [R t]= RPnP(XX,xx)
% XX is the 3D coordinate of the point set.
% xx is the ***normalized*** 2D coordinate of the projected point set.
% R is the estimated rotation matrix.
% t is the estimated translation vector.


(2) ./epnp/
% The EPnP algorithm by F. Moreno-Noguer, V. Lepetit, P. Fua.


(3) ./lhm/
% The LHM algorithm by Chien-Ping Lu et. al.


(4) ./sp/
% The SP algorithm for planar targets by G. Schweighofer and A. Pinz.
