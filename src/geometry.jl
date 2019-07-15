#
#	This file contains:
#    - findClosestPoint(Psimplex::Lar.Points, P::Lar.Points)::Int64
#	 - update(element, list)
#	 - sidePlane(point::Array{Float64,1}, axis::Array{Float64,1}, off::Float64)::Int64
#	 - splitValue(P::Lar.Points, axis::Array{Float64,1})
#	 - pointsetPartition(P::Lar.Points, axis::Array{Float64,1}, off::Float64)::Tuple{Array{Float64,2},Array{Float64,2}}
#	 - simplexFaces(t::Array{Int64,1})::Array{Array{Int64,1},1}
#	 - distPointPlane(point::Array{Float64,1}, axis::Array{Float64,1}, off::Float64)::Float64
#	 - planarIntersection(P::Lar.Points, f::Array{Int64,1} ,axis::Array{Int8,1}, off::Float64)::Int64
#	 - foundCenter(T::Array{Array{Float64,1},1})::Array{Float64,1}
#	 - foundRadius(T::Array{Array{Float64,1},1})::Float64
#	 - vertexInCircumball(T::Array{Array{Float64,1},1},
#			α_char::Float64,
#			point::Array{Float64,2}
#		):: Bool

#-------------------------------------------------------------------------------

"""
	findCenter(P::Lar.Points)::Array{Float64,1}

Evaluates the circumcenter of the `P` points.

If the points lies on a `d-1` circumball then the function is not able
to perform the evaluation and therefore returns a `NaN` array.

# Examples

```jldoctest
julia> V = [
	0.0 1.0 0.0 0.0
	0.0 0.0 1.0 0.0
	0.0 0.0 0.0 1.0
];

julia> AlphaStructures.findCenter(V)
3-element Array{Float64,1}:
 0.5
 0.5
 0.5

```
"""
function findCenter(P::Lar.Points)::Array{Float64,1}
	dim, n = size(P)
	@assert n > 0		"ERROR: at least one points is needed."
	@assert dim >= n-1	"ERROR: Too much points"

	@assert dim < 4		"ERROR: Function not yet Programmed."

	if n == 1
		center = P[:, 1]

	elseif n == 2
		#for each dimension
		center = (P[:, 1] + P[:, 2]) / 2

	elseif n == 3
		#https://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
		if dim == 2
			denom = 2 * Lar.det([ P[:, 2] - P[:, 1]  P[:, 3] - P[:, 1] ])
			deter = (P[:, 2] - P[:, 1]) * Lar.norm(P[:, 3] - P[:, 1])^2 -
					(P[:, 3] - P[:, 1]) * Lar.norm(P[:, 2] - P[:, 1])^2
			numer = [- deter[2], deter[1]]
			center = P[:, 1] + numer / denom

		elseif dim == 3
			#circumcenter of a triangle in R^3
			numer = Lar.norm(P[:, 3] - P[:, 1])^2 * Lar.cross(
						Lar.cross(P[:, 2] - P[:, 1], P[:, 3] - P[:, 1]),
						P[:, 2] - P[:, 1]
					) +
					Lar.norm(P[:, 2] - P[:, 1])^2 * Lar.cross(
				  		P[:, 3] - P[:, 1],
						Lar.cross(P[:, 2] - P[:, 1], P[:, 3] - P[:, 1]
					)
			)
			denom = 2 * Lar.norm(
				Lar.cross(P[:, 2] - P[:, 1], P[:, 3] - P[:, 1])
			)^2
			center = P[:, 1] + numer / denom
		end

	elseif n == 4 #&& dim = 3
		# https://people.sc.fsu.edu/~jburkardt/presentations
		#	/cg_lab_tetrahedrons.pdf
		# page 6 (matrix are transposed)
		α = LA.det([P; ones(1, 4)])
		sq = sum(abs2, P, dims = 1)
		Dx = LA.det([sq; P[2:2,:]; P[3:3,:]; ones(1, 4)])
		Dy = LA.det([P[1:1,:]; sq; P[3:3,:]; ones(1, 4)])
		Dz = LA.det([P[1:1,:]; P[2:2,:]; sq; ones(1, 4)])
		center = [Dx; Dy; Dz]/2α
	end

	return center
#	AlphaStructures.foundCenter([P[:,i] for i = 1 : size(P, 2)])[:,:]
end

#-------------------------------------------------------------------------------

"""
    findClosestPoint(Psimplex::Lar.Points, P::Lar.Points)::Int64

Returns the index of the closest point in `P` to the `Psimplex` points,
according to the circumcenter distance metric.
"""
function findClosestPoint(Psimplex::Lar.Points, P::Lar.Points)::Int64
    simplexDim = size(Psimplex, 2)
    @assert simplexDim <= size(Psimplex, 1) "Cannot add
        another point to the simplex"

    if simplexDim == 1
        findmin(
            [
                Lar.norm(Psimplex[:,1] - P[:,col])
                for col=1:size(P,2)
            ]
        )[2]
    else
        # radlist = [findRadius([Psimplex P[:,col]]) for col = 1:size(P,2)]
        # findmin(radlist)[2]
        findmin(
            [
                AlphaStructures.findRadius([Psimplex P[:,col]])
                for col = 1 : size(P, 2)
            ]
        )[2]
    end
end

#-------------------------------------------------------------------------------

"""
	findMedian(P::Lar.Points, ax::Int64)::Float64

Returns the median of the `P` points across the `ax` axis
"""
function findMedian(P::Lar.Points, ax::Int64)::Float64
	xp = sort(unique(P[ax, :]))
	idx = Int64(floor(length(xp)/2))
	return (xp[idx] + xp[idx+1])/2
end

#-------------------------------------------------------------------------------

"""
	findRadius(P::Lar.Points, center=false)

Returns the value of the circumball radius of the given points.
If the function findCenter is not able to determine the circumcenter
than the function returns `Inf`.

If the optional argument `center` is set to `true` than the function
returns also the circumcenter cartesian coordinates.

_Obs._ Due to numerical approximation errors, the radius is choosen
as the smallest distance between a point in `P` and the center.

# Examples
```jldoctest

julia> V = [
	0.0 1.0 0.0 0.0
	0.0 0.0 1.0 0.0
	0.0 0.0 0.0 1.0
];

julia> AlphaStructures.findRadius(V)
0.8660254037844386

julia> AlphaStructures.findRadius(V, true)
(0.8660254037844386, [0.5, 0.5, 0.5])

```
"""
function findRadius(P::Lar.Points, center=false)
 	c = AlphaStructures.findCenter(P)
	if any(isnan, c)
		r = Inf
	else
		r = findmin([Lar.norm(c - P[:, i]) for i = 1 : size(P, 2)])[1]
	end
	if center
		return r, c
	end
	return r
end
