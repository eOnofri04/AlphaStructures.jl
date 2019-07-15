#
#	This File Contains:
#	 - delaunayWall(P::Lar.Points, ax = 1)
#	 - firstDeWallSimplex(
#			P::Lar.Points,
#			ax::Int64,
#			off::Float64
#		)::Array{Int64,1}
#
#

"""
	delaunayWall(P::Lar.Points, ax = 1)

Return the Delaunay Triangulation of sites `P` via Delaunay Wall algorithm.
The optional argument `ax` specify on wich axis it will build the Wall.
"""

function delaunayWall(P::Lar.Points, ax = 1)

    dim = size(P, 1)
    n = size(P, 2)

    off = AlphaStructures.findMedian(P, ax)

    indices = firstDeWallSimplex(P, ax, off)
end

#-------------------------------------------------------------------------------

"""
function firstDeWallSimplex(
		P::Lar.Points,
		ax::Int64,
		off::Float64
	)::Array{Int64,1}

Returns the indices array of the points in `P` that form the first thetrahedron
built over the Wall if the `ax` axes with contant term `off`.

# Examples
```jldoctest

julia> V = [
	0.0 1.0 0.0 0.0 2.0
	0.0 0.0 1.0 0.0 2.0
	0.0 0.0 0.0 1.0 2.0
];

julia> firstDeWallSimplex(V, 1, AlphaStructures.findMedian(V,1))
4-element Array{Int64,1}:
 1
 2
 3
 4

```
"""

function firstDeWallSimplex(
		P::Lar.Points,
		ax::Int64,
		off::Float64
	)::Array{Int64,1}

	dim = size(P, 1)
    n = size(P, 2)

    # the first point of the simplex is the one with coordinate `ax` maximal
    #  such that it is less than `off` (closer to α from minus)
	Pselection = findall(x -> x < off, P[ax, :])
    newidx = Pselection[findmax(P[ax, Pselection])[2]]
    # indices will store the indices of the simplex ...
    indices = [newidx]                      #Array{Int64,1}
    # ... and `Psimplex` will store the corresponding points
    Psimplex = P[:, newidx][:,:]    #Array{Float64,2}

    # the second point must be seeken across those with coordinate `ax`
    #  grater than `off`
    Pselection = findall(x -> x > off, P[ax, :])

    for d = 1 : dim
        newidx = Pselection[
			AlphaStructures.findClosestPoint(Psimplex, P[:, Pselection])
		]
        indices = [indices; newidx]
        Psimplex = [Psimplex P[:, newidx]]
        Pselection = [i for i = 1 : n if i ∉ indices]
    end

    # Correctness check
	radius, center = AlphaStructures.findRadius(Psimplex, true)
    for i = 1 : n
		@assert Lar.norm(center - P[:, i]) >= radius "ERROR:
			Unable to find first Simplex."
	end

	return indices
end
