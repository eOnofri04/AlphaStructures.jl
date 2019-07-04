# 3.0 - Theory Index

This section has the purpose to introduce the theoretical concept behind the code in this module.
For this reason we will give a brief overview of:
 - Delaunay Triangulation in [section 3.1]()
 - Voronoy Diagram in [section 3.2]()
 - Alpha Complexs in [section 3.3]()
 - Persistent Homology in [section 3.4]()

In general we will assume ``S`` a set of sites (namely points in ``\mathbb R^D, D < \infrty``).
In the following we assume that ``S`` is made of points in a general position (_i.e._ no ``d+2`` points of ``S`` lie on a common ball). Of course this condition is not general (regardless of the name); however there’s a technique called SoS which "simulates an infinitesimal perturbation of the points", so that they are in general position afterwards.