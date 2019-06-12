# Introduction to ``\alpha``-shapes

Let ``S`` a set of ``n`` sites in ``\mathbb R^d`` (finite).
Since we are interested in real situation we will restrict to the case ``d \in \{2, 3\}``; however the following description could be simply enlarged for a general ``d`` value.

Suppose we want to build is something like "the shape formed by these points".
Of course it could be done in many ways: ``\alpha`` shapes are one of them.

As Edelbrunner and Mücke said in their paper [1] ``\alpha`` shapes could be thinked as the following.
Imagine a huge mass of ice-cream making up the space ``\mathbb R^d`` and containing the points ``S`` as "hard" chocolate pieces. Using one of these sphere-formed ice-cream spoons we carve out all parts of the ice-cream block we can reach without bumping into chocolate pieces, thereby even carving out holes in the inside (*eg.* parts not reachable by simply moving the spoon from the outside). We will eventually end up with a (not necessarily convex) object bounded by caps, arcs and points; we will call this object ``\alpha``-hull of ``S``. If we now straighten all "round" faces to triangles and line segments, we have an intuitive description of what is called the ``\alpha``-shape of ``S``, denoted by ``\mathcal T``.

But what is ``\alpha`` after all? In the ice-cream analogy above, ``\alpha`` is the squared radius of the carving spoon. A very small value will allow us to eat up all of the ice-cream except the chocolate points themselves. Thus for ``\alpha \to 0`` the alpha shape degenerates to the sites set ``S``. On the other hand, a huge value of ``\alpha`` will prevent us even from moving the spoon between two points since it is too large and we will never spoon up the ice-cream lying in the inside of the convex hull of ``S``. Hence, the ``\alpha``-shape becomes the convex hull of ``S`` as ``\alpha \to \infty``.



## Gemoetrical Concept

We will shortly discuss all the geometrical concepts that are needed to understand what an ``\alpha``-shape is.

In the following we assume that the set of sites ``S`` is made of points in a general position (no ``d+2`` points of ``S`` lie on a common ball). Of course this condition is not general (regardless of the name); however there’s a technique called SoS which "simulates an infinitesimal perturbation of the points", so that they are in general position afterwards.



### ``\alpha``-hulls and ``\alpha``-diagrams

First of all we need to identify what the spoon of the introduction is.

!!! definition
    For each ``0 < \alpha < \infty`` let an ``\alpha``-ball be an open ball with radius ``\alpha``.
    We will identify with ``B_x(\alpha)`` the ``\alpha``-ball centered in ``x``.
    For completenes we could therefore impose that ``B_x(0)`` represents the point ``x``.
    Now, a certain ``\alpha``-ball ``B`` (at a given location) is called empty if ``B \cap S = \emptyset``.

We can then define what an ``\alpha``-hull is, using the previous definition.

!!! definition
    For each ``0 < \alpha < \infty`` we define the ``\alpha``-hull ``\mathcal H_\alpha`` of ``S`` as the complement of the union of all empty ``\alpha``-balls:
    ```math
        \mathcal H_\alpha := \overline{ \bigcup_{x \in \mathbb R^d} \{D_\alpha(x) \mid D_\alpha(x) \cap S = \emptyset \} }
    ```


It follows from the previous definition the following three facts:
 - if ``\alpha_1 \leq \alpha_2`` then ``\mathcal H_{\alpha_1} \subseteq \mathcal H_{\alpha_2}``;
 - for ``\alpha\to\infty`` we obtain that ``\mathcal H_\alpha`` corresponds to the convex hull of ``S``;
 - ``\mathcal H_0 = S`` since only the sites are considered.

One more usefull concept related to what we are introducing is the ``\alpha``-diagramm defined as follows

!!! definition
    For each ``0 < \alpha < \infty`` we define the ``\alpha``-diagram ``\mathcal U_\alpha`` of ``S`` as the the union of all the ``\alpha``-balls centered in the sites of ``S``:
    ```math
        \mathcal U_\alpha :=  \bigcup_{s \in S} D_\alpha(s)
    ```

It is pretty clear that there is a strict relation between ``\mathcal H_\alpha`` and ``\mathcal U_\alpha``. In fact a point ``x`` belongs to ``\mathcal U_\alpha`` if and only if ``B_x(\alpha) \cap \mathcal H_\alpha \ne \emptyset``. Therefore we obtain the following relations
```math
	\begin{split}
		x \in \mathcal U_\alpha \iff B_x(\alpha) \cap \mathcal H_\alpha \ne \emptyset\\
		x \in \mathcal H_\alpha \iff B_x(\alpha) \subseteq \mathcal U_\alpha
	\end{split}
```

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



---

We can divide two kind of ``\alpha``-shapes:
 - **Basic ``\alpha``-shapes** are based on the Delaunay triangulation.
 - **Weighted ``\alpha``-shapes** are based on the regular triangulation, a Delunay generalization where the euclidean distance is replaced by the power to weighted points.
