#
#	This file contains:
#	 - findCenter(P::Lar.Points)::Array{Float64,1}
#	 - findClosestPoint(Psimplex::Lar.Points, P::Lar.Points)::Int64
#	 - findMedian(P::Lar.Points, ax::Int64)::Float64
#	 - findRadius(
#			P::Lar.Points, center=false; digits=64
#		)::Union{Float64, Tuple{Float64, Array{Float64,1}}}
#	 - oppositeHalfSpacePoints(
#			P::Lar.Points,
#			face::Array{Array{Int64,1},1},
#			point::Array{Float64,1}
#		)::Array{Int64,1}
#	 - planarIntersection(
#			P::Lar.Points,
#			face::Array{Int64,1},
#			axis::Int64,
#			off::Float64
#		)::Int64
#	 - simplexFaces(σ::Array{Int64,1})::Array{Array{Int64,1},1}
#	 - vertexInCircumball(
#			P::Lar.Points,
#			α_char::Float64,
#			point::Array{Float64,2}
#		)::Bool
#

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
	findClosestPoint(Psimplex::Lar.Points, P::Lar.Points)::Union{Int64, Nothing}

Returns the index of the closest point in `P` to the `Psimplex` points,
according to the circumcenter distance metric.
"""
function findClosestPoint(
		Psimplex::Lar.Points, P::Lar.Points
	)::Union{Int64, Nothing}

	simplexDim = size(Psimplex, 2)
    @assert simplexDim <= size(Psimplex, 1) "Cannot add
        another point to the simplex"

    if simplexDim == 1
        closestidx = findmin(
            [
                Lar.norm(Psimplex[:,1] - P[:,col])
                for col=1:size(P,2)
            ]
        )[2]
    else
        # radlist = [findRadius([Psimplex P[:,col]]) for col = 1:size(P,2)]
        # findmin(radlist)[2]
		radius, closestidx = findmin([
			AlphaStructures.findRadius([Psimplex P[:,col]])
			for col = 1 : size(P, 2)
		])
		if radius == Inf
			closestidx = nothing
		end
    end

	return closestidx

end

#-------------------------------------------------------------------------------

"""
	findMedian(P::Lar.Points, ax::Int64)::Float64

Returns the median of the `P` points across the `ax` axis
"""
function findMedian(P::Lar.Points, ax::Int64)::Float64
	xp = sort(unique(P[ax, :]))
	if length(xp) == 1
		median = xp[1]
	else
		idx = Int64(floor(length(xp)/2))
		median = (xp[idx] + xp[idx+1])/2
	end
	return median
end

#-------------------------------------------------------------------------------

"""
	findRadius(
		P::Lar.Points, center=false; digits=64
	)::Union{Float64, Tuple{Float64, Array{Float64,1}}}

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
function findRadius(
		P::Lar.Points, center=false; digits=64
	)::Union{Float64, Tuple{Float64, Array{Float64,1}}}

 	c = AlphaStructures.findCenter(P)
	if any(isnan, c)
		r = Inf
	else
		r = round(
			findmin([Lar.norm(c - P[:, i]) for i = 1 : size(P, 2)])[1],
			digits = digits
		)
	end
	if center
		return r, c
	end
	return r
end

#-------------------------------------------------------------------------------
"""
	oppositeHalfSpacePoints(
			P::Lar.Points,
			face::Array{Array{Int64,1},1},
			point::Int64
		)::Array{Int64,1}

Returns the index list of the points `P` located in the halfspace defined by
`face` points that do not contains the point `point`.

_Obs._ Dimension Dipendent, only works if dimension is three or less and
	the number of points in the face is the same than the dimension.

# Examples
```jldoctest
julia> V = [
		0.0 1.0 0.0 0.0 4.0 -1. 1.0
		0.0 0.0 1.0 0.0 1.0 0.0 1.0
		0.0 0.0 0.0 1.0 2.0 0.0 1.0
	   ];

julia> oppositeHalfSpacePoints(V, [2; 3; 4], 1)
2-element Array{Int64,1}:
 5
 7

julia> oppositeHalfSpacePoints(V, [1; 2; 3], 4)
0-element Array{Int64,1}

julia> oppositeHalfSpacePoints(V, [1; 3; 4], 2)
1-element Array{Int64,1}:
 6

```
"""
function oppositeHalfSpacePoints(
		P::Lar.Points,
		face::Array{Int64,1},
		point::Int64
	)::Array{Int64,1}

	dim, n = size(P)
	@assert dim <= 3 "ERROR: Not yet coded."
	@assert length(face) == dim "ERROR:
		Cannot determine opposite to non hyperplanes."
	if dim == 1
		threshold = P[1, face[1]]
		if P[1, point] < threshold
			opposite = [i for i = 1 : n if P[1, i] > threshold]
		else
			opposite = [i for i = 1 : n if P[1, i] < threshold]
		end
	elseif dim == 2
		m = (P[2, face[1]] - P[2, face[2]]) / (P[1, face[1]] - P[1, face[2]])
		q = P[2, face[1]] - m * P[1, face[1]]
		# false = under the line, true = over the line
		@assert P[2, point] ≠ m * P[1, point] + q "ERROR,
			the point belongs to the face"
		if P[2, point] < m * P[1, point] + q
			opposite = [i for i = 1 : n if P[2, i] > m * P[1, i] + q]
		else
			opposite = [i for i = 1 : n if P[2, i] < m * P[1, i] + q]
		end
	elseif dim == 3
		axis = Lar.cross(
			P[:, face[2]] - P[:, face[1]],
			P[:, face[3]] - P[:, face[1]]
		)
		off = Lar.dot(axis, P[:, face[1]])
		position = Lar.dot(P[:, point], axis)
		if position < off
			opposite = [i for i = 1:size(P, 2) if Lar.dot(P[:,i], axis) > off]
		else
			opposite = [i for i = 1:size(P, 2) if Lar.dot(P[:,i], axis) < off]
		end
	end
	return setdiff(opposite, face)
end

#-------------------------------------------------------------------------------

"""
	planarIntersection(
		P::Lar.Points,
		face::Array{Int64,1},
		axis::Int64,
		off::Float64
	)::Int64

Computes the position of `face` with respect to the hyperplane `α` defined by
the normal `axis` and the contant term `off`. It returns:
 - `+0` if `f` intersect `α` internum (not only the boundary)
 - `+1` if `f` is completely contained in the positive half space of `α`
 - `-1` if `f` is completely contained in the negative half space of `α`
"""
function planarIntersection(
		P::Lar.Points,
		face::Array{Int64,1},
		axis::Int64,
		off::Float64
	)::Int64

	pos = [P[axis, i] > off for i in face]

	if sum([P[axis, i] == off for i in face]) == length(pos)
		position = 0 # face coplanar with axis
	elseif sum(pos) == 0
		position = -1
	elseif sum(pos) == length(pos)
		position = +1
	else
		position = 0
	end

	return position
end

#-------------------------------------------------------------------------------

"""
	simplexFaces(σ::Array{Int64,1})::Array{Array{Int64,1},1}

Returns the faces of the simplex `σ`.

_Obs._ The faces are ordered by the index value.

# Examples
```jldoctest

julia> σ = [1; 3; 2; 4];

julia> AlphaStructures.implexFaces(σ)
4-element Array{Array{Int64,1},1}:
 [1, 2, 3]
 [1, 2, 4]
 [1, 3, 4]
 [2, 3, 4]

```
"""
function simplexFaces(σ::Array{Int64,1})::Array{Array{Int64,1},1}
    sort!(sort!.(collect(Combinatorics.combinations(σ, length(σ)-1))))
end

#-------------------------------------------------------------------------------

"""
	vertexInCircumball(
		P::Lar.Points,
		α_char::Float64,
		point::Array{Float64,2}
	)::Bool

Determine if a point is inner of the circumball determined by `P` points
	and radius `α_char`.

"""
function vertexInCircumball(
		P::Lar.Points,
		α_char::Float64,
		point::Array{Float64,2}
	)::Bool

	center = AlphaStructures.findCenter(P)
	return Lar.norm(point - center) <= α_char
end
