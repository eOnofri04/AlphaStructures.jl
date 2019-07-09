# 1 - AlphaStructures.jl

`AlphaStructures.jl` is a [Julia](http://julialang.org) library that provides some tool for point cloud analysis.

With `AlphaStructures.jl` you can:
 - evaluate the ``\alpha``-Shape of a point cloud
 - compute the ``\alpha``-Filtration of a point cloud
 - build the ``\alpha``-Complex of a point cloud
 - find some basics about Persistent Homology evaluation of a cloud of points

In this documentation we present the problem and the related solution we have implemented so far both from the mathematical [EM92] and the computer science [Ede14] point of view.


## Dependencies

`AlphaStructures.jl` has the following dependeces:
 - [```Combinatorics.jl```](https://github.com/JuliaMath/Combinatorics.jl) by Julia Math
 - [```DataStructures.jl```](https://github.com/JuliaCollections/DataStructures.jl) by Julia Collections
 - [```LinearAlgebraicRepresentation```](https://github.com/cvdlab/LinearAlgebraicRepresentation.jl) by CVD Lab
 - [```Triangle.jl```](https://github.com/cvdlab/Triangle.jl) by CVD Lab

and as additional dependece:
 - [Plasm](https://github.com/cvdlab/Plasm.jl) by CVD Lab


## Docstrings conventions

 - **Bold** is used to point out theory concepts.
 - `Monospace` is used for everything code related.

## Table of Contenents

```@contents
```