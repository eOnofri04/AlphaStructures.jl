# 4.2 - Alpha Structures Implementation

As previously said in [section 3.3](https://eonofri04.github.io/AlphaShape.jl/alpha-structures/) we have addressed the problem of evaluate ``\alpha``-strutcures via ``\alpha``-filtering evaluation (namely the evaluation of the charateritcial ``\alpha`` for each simplex).

## The tasks

We could decompose the problem into three tasks:
 - evaluate the triangulation decomposition of the Sites ``S``
 - evaluate the charateristical ``\alpha``
 - sort the simplices according to their ``\alpha``.

The first task to solve is to evaluate the Triangulation. However we have discussed this problem in the [previous section](https://eonofri04.github.io/AlphaShape.jl/delaunay-impl/).

The last task also is pretty simple and teherefore we will not talk about it in this context.

The second task is the hardest to achieve.
It is pretty clear that each site ``s \in S`` has a charateristical ``\alpha`` equal to zero.
The real problem occurs then when we want to evaluate the charateristical ``\alpha`` of all the other simplices.

### Evaluate Charateristical ``\alpha``

In order to obtain a simple method to evaluate charateristical ``\alpha`` so that it is dimensional indipendent we could use the dual of the Delaunay Triangulation we have described in [section 3.2](https://eonofri04.github.io/AlphaShape.jl/voronoy/): the Voronoy Diagram.

In fact the following relation occurs:
!!! fact
    A ``d``-dimensional simplex ``\sigma`` is inside the ``\alpha``-complex if and only if and only if the Voronoy regions of the sites of ``sigma`` have a common ``D-d`` intersection hyperplane included in the ``alpha``-hypersphere of the sites themselves. In other words:
    ```math
    	\sigma \in \mathcal A_\alpha(S)
    	\quad \iff \quad
    	\bigcap_{t \in \sigma) \left(V_t(\alpha) \cap B_t(\alpha)\right) \ne \emptyset
    ```

To simplify this notion we could refer to what happend in the two dimensional case:
!!! example
    Let ``S \in \mathbb R^2`` then:
     - an edge ``\overline{st}`` occurs in the ``alpha``-complex if and only if the voronoy regions of ``s`` and ``t`` meet in a common edge that is less far from ``s`` and ``t`` than ``\alpha``;
     - a triangle ``stq`` occurs in the ``alpha``-complex if and only if the voronoy regions of ``s``, ``t`` and ``q`` meet in a common point that is closer than ``\alpha`` from the points themselves.

Of course we could overturn the point of view by looking what happend if we consider the ``d-1``-dimensional ball centered in the center of the circumball defined by the ``d`` sites of ``\sigma``.

First of all we are sure it is well defined and unique since ``S`` satisfies the general position condition.

## The Implementation

The solution we have proposed is located in the `alphaFilter` function (in [this](https://github.com/eOnofri04/AlphaShape.jl/blob/master/src/alpha_complex.jl) file):
```@docs
AlphaShape.alphaFilter
```

### The Pipeline

The approach we have followed could be summed up into the following pipeline:
 1. Delaunay triangulation of the Sites ``S`` (highest degree simplices)
 2. Construction of lower degree simplices via `Combinatorics.combinations()`
 3. Evaluation of Circumballs Radius for each simplex
 4. Evaluation of the Charatteristical ``\alpha`` for each simplex
 5. Sorting the simplices by their ``\alpha`` in a `DataStructures.SortedMultiDict`