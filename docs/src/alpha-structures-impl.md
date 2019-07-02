# Alpha Structures Implementation (ToDo)

## 2 and 3 dimensional problem resolution

In order to describe in a better way the procedure to build an ``\alpha``-complex we will restrict to the case ``d = 2, 3``. Of course the proposed method is totally general but this way we will keep the description simple.

### Delunay Triangulation and Voronoy Diagrams

We can define a Delunay Triangulation ``\mathcal D`` over the set ``S`` and, since the general position condition is satisfied by hypotesis, it follows that the thetrahedra decomposition of the convex hull it's unique.

For ``0 \leq k \leq 3`` we can define ``F_k`` as the ``k``-simplices set of ``\mathcal D``. It is pretty clear that if a simplex ``\sigma \in F_k`` belongs to ``\mathcal T`` then it will also belong to ``\mathcal D``. It could however be proven that for all the ``k``-simplices ``\sigma`` of ``F_k`` there exists a ``\bar\alpha`` such that ``\sigma`` belongs to ``F_{k, \bar\alpha}`` (namely the ``\bar\alpha``-shape ``k``-simplices):
```math
	F_k = \bigcup_{0 \leq \alpha \leq \infty} F_{k, \alpha}, \qquad \forall k \in \{0, 1, 2, 3\}
```
We will call ``\bar\alpha`` as *Charateristic ``\alpha`` of the simplex ``\sigma``* and we will denote it like ``\alpha_\sigma``. It is usefull then to sort the simplices according to their ``\alpha``-charateristic.

We then obtain a sorted finite set
```math
    A_S = \{\alpha_{\sigma_i} \mid \sigma_i \in F_k, \exists k = 1, 2, 3\}
```

However in order to determine ``A_S`` there is a better path than evaluate each single ``\alpha``-charateristic. This strategy relies on the dual contruction of Delaunay Triangulation: Voronoy Diagrams.

Let ``\mathcal V`` be the Voronoy Decomposition of ``S``. For all site ``t \in S`` we will denote ``V_t`` the Voronoy cell of ``t``.

#### ``Dimension 2``
``\alpha_\sigma`` could be determined as follows:
 - if ``\sigma \in F_0`` then ``\alpha_\sigma = 0``
 - if ``\sigma \in F_2`` then ``\alpha_\sigma`` is the radius of the circumcircle of the triangle
 - if ``\sigma = \overline{st} \in F_1`` then two cases arise:
   - if ``\overline{st}`` intersect the Voronoy segment between ``V_s`` and ``V_t`` (namely ``\overline{st} \cap V_s \cap V_t \ne \emptyset``) then ``\alpha_\sigma = \|\sigma\|/2``
   - if ``\overline{st}`` do not intersect the Voronoy segment then there exists ``u \in S`` such that the angle ``s\ \hat{u}\ t > \pi/2``. Then ``\alpha_\sigma`` is the radius of the circumcircle of the triangle ``sut``.

It is trivial that ``0``-cells always are in the ``\alpha``-Complex.

Moreover it is also pretty clear that if a ``2``-cell belongs to the ``\alpha``-complex then also its ``1``-cells are part of it.

#### ``Dimension 3``
``\alpha_\sigma`` could be determined as follows:
 - if ``\sigma \in F_0`` then ``\alpha_\sigma = 0``
 - if ``\sigma \in F_3`` then ``\alpha_\sigma`` is the radius of the circumsphere of the tethrahedron.