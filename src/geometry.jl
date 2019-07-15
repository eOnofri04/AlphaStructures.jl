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
	findCenter(P::Lar.Points)

Utility function to change Lar.Points->{Array{Array,1},1}
Will be removed ?
"""
function findCenter(P::Lar.Points)::Array{Float64,2}
	AlphaStructures.foundCenter([P[:,i] for i = 1 : size(P, 2)])[:,:]
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
                findRadius([Psimplex P[:,col]])
                for col = 1 : size(P, 2)
            ]
        )[2]
    end
end

#-------------------------------------------------------------------------------

"""
	findRadius(P::Lar.Points)

Utility function to change Lar.Points->{Array{Array,1},1}
Will be removed ?
"""
function findRadius(P::Lar.Points, center = false)
 	c = AlphaStructures.foundCenter([P[:,i] for i = 1 : size(P, 2)])[:,:]
	r = findmin([Lar.norm(c - P[:, i]) for i = 1 : size(P, 2)])[1]
	if r == NaN
		r = Inf
	end
	if center
		return r, c
	end
	return r
end
