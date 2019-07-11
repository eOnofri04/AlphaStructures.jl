# 4.1 - 3D Delaunay Triangulation

For 3D Delaunay Triangulation of a pointset P ``DT(P)``, we use DeWall algorithm of P. Cignoni, C. Montani, R. Scopigno, that can be generalized to ``E^d`` triangulations.

## Advantage

The duality between DTs and Voronoi diagrams is well known and therefore algorithms
are given for the construction of DT from Voronoi diagrams.
However, direct construction methods are generally more efficient because the Voronoi diagram does not need to be computed and stored. The direct DT algorithm that we use is **divide & conquer** (D&C).
This is based on the recursive partition and local triangulation of the point set, and then on a merging phase where the resulting triangulations are joined.
 - Classic D&C algorithms: recursively subdivide the input dataset, construct the two DTs and then merge them.
 - DeWall algorithm: first subdivides the input dataset, then builds that part of the DT that should be built in the merge phase of a classic D&C algorithm and then recursively triangulates the two half–spaces, taking into account the border of the previously computed merge triangulation.

## A recursive function

The DeWall (Delaunay Wall) algorithm consists of the following steps:
 - select the splitting plane π;
 - split ``P`` into two subset ``P^-`` and ``P^+`` and construct ``S^π``;
 - recursively apply DeWall on ``P^-``, starting from ``S^π``, and build ``S^-``;
 - recursively apply DeWall on ``P^+``, starting from ``S^π``, and build ``S^+``;
 - return the union of ``S^π``, ``S^-`` and ``S^+``.

 The splitting plane π divides the space into two halfspaces: positive halfspace and negative halfspace.
 Plane π divides a triangulation ``DT(P)`` into three subsets:
  - the simplices that are intersected by the plane, which we call **simplex wall** ``S^π`` ,
  - the simplices ``S^+`` that are completely contained in the positive halfspace and
  - the simplices ``S^-`` completely contained in the negative halfspace.

### Construct simplex wall

The simplex wall can be simply computed by using an incremental construction approach.

The algorithm starts by constructing an initial simplex ``σ_i`` that intersect the plane; then, it processes all of the ``(d - 1)-face`` of ``σ_i``: the simplex adjacent to each of them (if it exists, i.e. the face does not belong to the convex hull of ``P``) is built and added to the current list of simplices in ``DT(P)``. All of the new ``(d - 1)-face`` of each new simplex are used to update a data structure, here called Active Face List (AFL).
!!! fact
  For each ``(d - 1)-face`` ``f``, which does not lie on the convex hull of ``P``, there are exactly two simplices ``σ_1`` and ``σ_2`` in ``DT(P)``, such that ``σ_1`` and ``σ_2`` share the ``(d - 1)-face`` ``f``.
  So to update the AFL we considered that: if a new face is already contained in AFL, then it is removed from AFL;
  otherwise, it is inserted in AFL because its adjacent simplex has not yet been built.

The process continues iteratively:
 - extract a face ``f`` from AFL,
 - build the simplex ``σ`` adjacent to ``f``,
 - update the AFL with the ``(d - 1)-face`` of ``σ``, and then again
 - extract another face from AFL
 - until AFL is empty.

## The implementation
The main functions to compute this are in [this](https://github.com/eOnofri04/AlphaStructures.jl/blob/master/src/3D_delaunay.jl) file
```@docs
AlphaStructures.makeFirstWallSimplex
```
```@docs
AlphaStructures.makeSimplex
```
```@docs
AlphaStructures.deWall
```


### The Pipeline

 1. Select the plane π to split ``P``;
 2. Split ``P`` into two subset ``P^-`` and ``P^+``;
 3. Construct first simplex of ``S^π`` with `makeFirstWallSimplex`
 4. Construct adjacent simplex to complite ``S^π`` with `makeSimplex`
 5. Construct ``S^-`` and ``S^+``, recursively appling `deWall` on ``P^-`` and ``P^+``, starting from ``S^π``.
 7. Return the union of ``S^π``, ``S^-`` and ``S^+``.
