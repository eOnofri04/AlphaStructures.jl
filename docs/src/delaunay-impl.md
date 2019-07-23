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
 1. select a plane π that divides the space into two halfspaces;
 2. split ``P`` into two subset ``P^-`` in the negative halfspace and ``P^+`` in the positive one;
 3. construct ``S^π``;
 4. recursively apply DeWall on ``P^-``, starting from ``S^π``, and build ``S^-``
 5. recursively apply DeWall on ``P^+``, starting from ``S^π``, and build ``S^+`` (the simplices that are completely contained in the positive halfspace);
 6. merge ``S^π``, ``S^-`` and ``S^+``.

 Where
 ``S^π = {σ_i: σ_i ∩ π ≠ ∅ }``,
 ``S^- = {σ_i: σ_i ⊂ NegHalfspace(π)}``,
 ``S^+ = {σ_i: σ_i ⊂ PosHalfspace(π)}``.

### Construct simplex wall ``S^π``

The simplex wall ``S^π`` can be simply computed by using an incremental construction approach.

First of all we need three **active face lists**:
 - ``AFL^π``: the ``(d - 1)-faces`` intersected by plane;
 - ``AFL^+``: the ``(d - 1)-faces`` with all of the vertices in ``P^+``;
 - ``AFL^-``: the ``(d - 1)-faces`` with all of the vertices in ``P^-``.

The algorithm starts by constructing an initial ``d``-simplex ``σ_i`` that intersect the plane; then, it processes all of the ``(d - 1)-faces`` of ``σ_i``: the ``d``-simplex adjacent to each of them (if it exists, i.e. the face does not belong to the convex hull of ``P``) is built and added to the current list of simplices in ``DT(P)``. All of the new ``(d - 1)-faces`` of each new ``d``-simplex are used to update the right active face list (AFL).
!!! fact
  For each ``(d - 1)-face`` ``f``, which does not lie on the convex hull of ``P``, there are exactly two simplices ``σ_1`` and ``σ_2`` in ``DT(P)``, such that ``σ_1`` and ``σ_2`` share ``f``.
  So to update the AFL we considered that: if a new face ``f`` is already contained in AFL, then it is removed from AFL; otherwise, it is inserted in AFL because its adjacent simplex has not yet been built.

The process continues iteratively:
 - extract a face ``f`` from ``AFL^π``,
 - build the ``d``-simplex ``σ`` adjacent to ``f``,
 - update AFLs with the ``(d - 1)-face`` of ``σ``, and then again
 - extract another face from ``AFL^π`` until is empty.

### A recursive call

Once the simplex wall is computed, DeWall is recursively applied to the pairs (``P^-``, ``AFL^-``) and (``P^+``, ``AFL^+``), unless all the active face lists are empty. The splitting plane is cyclically selected as a plane orthogonal to the axes of the ``E^d`` space, in order to recursively partition the space with a regular pattern.

### The Pipeline

 1. Select the plane π to split ``P``;
 2. Split ``P`` into two subset ``P^-`` and ``P^+``;
 3. Construct first simplex of ``S^π`` with `firstDeWallSimplex`;
 4. Construct adjacent simplex to complite ``S^π`` with `findWallSimplex`;
 5. Update all AFLs;
 6. Construct ``S^-`` and ``S^+``, recursively appling `delaunayWall` on ``P^-`` and ``P^+``, starting from associated AFL;
 7. Return the union of ``S^π``, ``S^-`` and ``S^+``.

## Examples

The input is a set of points in ``\mathcal R^d``, of type `Lar.Points`, the output is a set of ``d``-simplices, of type `Lar.Cells`.
So we can create a LAR model to view.

### 3D Delaunay triangulation

```julia

julia> using AlphaStructures, Plasm

julia> V = [
               0.0 1.0 0.0 1.0 0.0 1.0 0.0 1.0
               0.0 0.0 1.0 1.0 0.0 0.0 1.0 1.0
               0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0
           ];

julia> DT = AlphaStructures.delaunayWall(V)
6-element Array{Array{Int64,1},1}:
 [1, 2, 4, 5]
 [1, 3, 4, 5]
 [2, 4, 5, 6]
 [3, 4, 5, 7]
 [4, 5, 6, 7]
 [4, 6, 7, 8]

julia> Plasm.viewexploded(V,DT)(1.2,1.2,1.2);

```

### 2D Delaunay triangulation
```julia

julia> using AlphaStructures, Plasm

julia> V = [
            0.0 2.0 0.0 4.0 5.0 ;
            0.0 0.0 3.0 1.0 5.0
            ];

julia> DT = AlphaStructures.delaunayWall(V)
3-element Array{Array{Int64,1},1}:
 [2, 3, 4]
 [3, 4, 5]
 [1, 2, 3]

julia> Plasm.viewexploded(V,DT)(1.2,1.2);

```

## Main Interface

 ```@docs
 AlphaStructures.firstDeWallSimplex
 ```
 ```@docs
 AlphaStructures.findWallSimplex
 ```
 ```@docs
 AlphaStructures.delaunayWall
 ```
