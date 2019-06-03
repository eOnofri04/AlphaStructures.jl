# Theoretical Introduction to ``\alpha``-shapes

Let ``S`` a set of ``n`` sites in ``\mathbb R^d`` (finite).
Suppose we want to build is something like "the shape formed by these points".
Of course it could be done in many ways: ``\alpha`` shapes are one of them.

As Edelbrunner and Mücke said in their paper [1] ``alpha`` shapes could be thinked as the following.
Imagine a huge mass of ice-cream making up the space ``\mathbb R^d`` and containing the points ``S`` as "hard" chocolate pieces. Using one of these sphere-formed ice-cream spoons we carve out all parts of the ice-cream block we can reach without bumping into chocolate pieces, thereby even carving out holes in the inside (*eg.* parts not reachable by simply moving the spoon from the outside). We will eventually end up with a (not necessarily convex) object bounded by caps, arcs and points. If we now straighten all “round” faces to triangles and line segments, we have an intuitive description of what is called the ``alpha``-shape of ``S``.

But what is ``alpha`` after all? In the ice-cream analogy above, ``alpha`` is the squared radius of the carving spoon. A very small value will allow us to eat up all of the ice-cream except the chocolate points themselves. Thus for ``\alpha \to 0`` the alpha shape degenerates to the sites set ``S``. On the other hand, a huge value of ``\alpha`` will prevent us even from moving the spoon between two points since it is too large and we will never spoon up the ice-cream lying in the inside of the convex hull of ``S``. Hence, the ``\alpha``-shape becomes the convex hull of ``S`` as ``\alpha \to \infty``.

## Introduction

In the following we assume that the set of sites ``S`` is made of points in a general position (no ``d+2`` points of ``S`` lie on a common ball). Of course this condition is not general (regardless of the name); however there’s a technique called SoS which "simulates an infinitesimal perturbation of the points", so that they are in general position afterwards.

First of all we need to identify what the spoon of the introduction is.

!!!Definition
    For each ``0 \leq \alpha < \infty`` let an ``\alpha``-ball be a closed ball with radius ``\alpha``.
    We will identify with ``D_x(\alpha)`` the ``\alpha``-ball centered in ``x``.
    Therefore a ``0``-ball represents the point ``x``.
    Now, a certain ``\alpha``-ball ``b`` (at a given location) is called empty if ``b \cap S = \emptyset``.

We can divide two kind of ``\alpha``-shapes:
 - **Basic ``\alpha``-shapes** are based on the Delaunay triangulation.
 - **Weighted ``\alpha``-shapes** are based on the regular triangulation, a Delunay generalization where the euclidean distance is replaced by the power to weighted points.
