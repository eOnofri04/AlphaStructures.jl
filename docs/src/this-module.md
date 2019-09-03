# 4.0 - Module Introduction

In this module we have solved the problem of building an ``\alpha``-complex for a generic dimension.

One of the most sensible problem was that no Julia modules exists for ``d``-dimensional Delaunay Triangulation so far.
We have tackled this problem and we have solved it in a pretty good way by coding the Delaunay Wall algorithm by P. Cignoni, C. Montani and R. Scopigno.
Even though we have preferred to use [`Triangle.jl`](https://github.com/cvdlab/Triangle.jl) by CVD Lab for 2-dimensional planes due to the fact larger test sets have been carried out over that module.


In [section 4.1](https://eonofri04.github.io/AlphaStructures.jl/delaunay-impl/) we will discuss how we have solved the Delauanay Triangulation problem for a generic ``d``-dimensional space via Delaunay Wall Algorithm

In [section 4.2](https://eonofri04.github.io/AlphaStructures.jl/alpha-structures-impl/) we will talk about solving the problem of finding the characteristical ``\alpha`` of the simplices in order to build the ``\alpha``-Structures.

Lastly, in [section 4.3](https://eonofri04.github.io/AlphaStructures.jl/persistent-homology-impl/) we will give a brief overview of how we solved the Persistent Homology problem.

More utility functions could also be found in the [`src/geometry.jl`](https://github.com/eOnofri04/AlphaStructures.jl/blob/master/src/geometry.jl) file.
