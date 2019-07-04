# 4.0 - Module Introduction

In this module we have solved the problem of building an ``\alpha``-complex for a generical dimension. However the module could only solve two and three dimensional istances of the problem. The reason is that no library for ``d``-dimensional Delaunay Triangulation exists in Julia so far.

In [section 4.1](https://eonofri04.github.io/AlphaShape.jl/delaunay-impl/) we will discuss how we have solved the Delauanay Triangulation problem for 3-dimensional spaces (since we have used [`Triangle.jl`](https://github.com/cvdlab/Triangle.jl) by CVD Lab for 2-dimensional planes).

In [section 4.2](https://eonofri04.github.io/AlphaShape.jl/alpha-structures-impl/) we will talk about solving the problem of finding the charateristical ``\alpha`` of the simplices in order to build the ``\alpha``-Structures.

Lastly, in [section 4.3](https://eonofri04.github.io/AlphaShape.jl/persistent-homology-impl/) we will give a brief overview of how we solved the Persistent Homology problem.