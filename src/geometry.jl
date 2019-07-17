#
#	This file contains:
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


"""
	update(element,list)

Return update `list`: if `element` ∈ `list`, delete `element`, else push the `element`.
"""
function update(element, list)
	if element ∈ list
        	setdiff!(list, [element])
	else
		push!(list, element)
	end
	return list
end



"""
	sidePlane(point::Array{Float64,1}, axis::Array{Float64,1}, off::Float64)::Int64

Given a `point` and a hyperplane `α` (defined by a normal `axis` and a contant term `off`) it returns:
 - `+0`  if `point` is on plane.
 - `+1`  if `point` is in the positive half-space.
 - `-1`  if `point` is in the negative half-space.
"""
function sidePlane(point::Array{Float64,1}, axis::Array{Float64,1}, off::Float64)::Int64
	side = round(Lar.dot(point,axis), sigdigits = 14)
	if side > off+1.e-14 return 1
	elseif side < off-1.e-14 return -1
	else return 0
	end
end



"""
    splitValue(P::Lar.Points, axis::Array{Float64,1})

Return threshold value for splitting plane α of pointset `P`. The splitting
plane α is selected as a plane orthogonal to the axes (X, Y or Z in ``E^3`` ), so:
	- axis = [1.,0,0] or
	- axis = [0,1.,0] or
	- axis = [0,0,1.].
"""
function splitValue(P::Lar.Points, axis::Array{Float64,1})
	@assert axis == [1.,0,0] || axis == [0,1.,0] || axis == [0,0,1.] "splitValue: not a plane orthogonal to the axes "
	coord = findall(x->x==1.,axis)[1]
	valueP = sort(unique(P[coord,:]))
	numberPoint = length(valueP)
	if numberPoint == 1
		return nothing
	else
    		off = (valueP[floor(Int,numberPoint/2)] + valueP[floor(Int,numberPoint/2)+1])/2
		return off
	end
end



"""
    pointsetPartition(P::Lar.Points, axis::Array{Float64,1}, off::Float64)::Tuple{Array{Float64,2},Array{Float64,2}}

Return two subsets of pointset `P` split by α plane defined by `axis` and `off`.
"""
function pointsetPartition(P::Lar.Points, axis::Array{Float64,1}, off::Float64)::Tuple{Array{Float64,2},Array{Float64,2}}
	side = [AlphaStructures.sidePlane(P[:,i],axis,off) for i = 1:size(P,2)]
	Pminus = P[:,side.== -1 ] #points in negative halfspace
	Pplus = P[:,side.== 1] #points in positive halfspace
	return Pminus,Pplus
end



"""
    simplexFaces(t::Array{Int64,1})::Array{Array{Int64,1},1}

Return `d-1`-faces of a `d`-simplex.
"""
function simplexFaces(t::Array{Int64,1})::Array{Array{Int64,1},1}
    d = length(t)
    return collect(Combinatorics.combinations(t, d-1))
end



"""
	distPointPlane(point::Array{Float64,1},axis::Array{Float64,1},off::Float64)::Float64

Return the distance between `point` and hyperplane α defined by `axis` and `off`.
"""
function distPointPlane(point::Array{Float64,1},axis::Array{Float64,1},off::Float64)::Float64
	num = abs(Lar.dot(point,axis)-off)
	den = Lar.norm(axis)
	return num/den
end



"""
	planarIntersection(P::Lar.Points, f::Array{Int64,1} ,axis::Array{Int8,1}, off::Float64)::Int64

Given a face `f` and a plane `α` (defined by the normal `axis` and the contant term `off`) it returns:
 - `+0` if `f` intersect `α`
 - `+1` if `f` is completely contained in the positive half space of `α`
 - `-1` if `f` is completely contained in the negative half space of `α`
"""
function planarIntersection(Ptot::Lar.Points, P::Lar.Points, f::Array{Int64,1} ,axis::Array{Float64,1}, off::Float64)::Int64

	p1,p2,p3 = [Ptot[:,i] for i in f]

	v1 = sidePlane(p1, axis, off)
	v2 = sidePlane(p2, axis, off)

	if v1 != v2
		return 0;
	end

 	v3 = sidePlane(p3, axis, off)

	if v1 != v3
		return 0
    else
		return v1
	end
end

"""
	foundCenter(T::Array{Array{Float64,1},1})::Array{Float64,1}

Determine center of a simplex defined by `T` points.

"""
function foundCenter(T::Array{Array{Float64,1},1})::Array{Float64,1}
	@assert length(T) > 0 "foundCenter: at least one points is needed."
	dim = length(T[1])
	@assert dim < 4 "foundCenter: Function not yet Programmed."
	k = length(T)-1

	if k == 0
		center = T[1]

	elseif k == 1
		#for each dimension
		center = (T[1] + T[2])/2

	elseif k == 2
		#https://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
		if dim == 2
			den = 2*Lar.det([T[2]-T[1] T[3]-T[1]])
			det = (T[2]-T[1])*Lar.norm(T[3]-T[1])^2 -
						(T[3]-T[1])*Lar.norm(T[2]-T[1])^2
			num = [-det[2],det[1]]
			center = T[1] + num / den

		elseif dim == 3
			#circumcenter of a triangle in R^3
			num = Lar.norm(T[3]-T[1])^2 *
					Lar.cross( Lar.cross(T[2]-T[1], T[3]-T[1]), T[2]-T[1] ) +
				Lar.norm(T[2]-T[1])^2 *
					Lar.cross( T[3]-T[1], Lar.cross(T[2]-T[1], T[3]-T[1] )
			)
			den = 2*Lar.norm( Lar.cross(T[2]-T[1], T[3]-T[1]) )^2
			center = T[1] + num / den
		end

	elseif k == 3
		#https://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
		if dim == 3
			num = Lar.norm(T[4]-T[1])^2*Lar.cross(T[2]-T[1],T[3]-T[1]) +
				Lar.norm(T[3]-T[1])^2*Lar.cross(T[4]-T[1],T[2]-T[1]) +
				Lar.norm(T[2]-T[1])^2*Lar.cross(T[3]-T[1],T[4]-T[1])
			M = [T[2]-T[1] T[3]-T[1] T[4]-T[1]]
			den = 2*Lar.det(M)
			center = T[1] + num / den
		end
	end

	return center
end

"""
	foundRadius(T::Array{Array{Float64,1},1})::Float64

Return the value of the circumball radius of the given points.
If three or more points are collinear it returns `NaN`.
"""
function foundRadius(T::Array{Array{Float64,1},1})::Float64

	@assert length(T) > 0 "foundRadius: at least one points is needed."
	dim = length(T[1])
	@assert dim < 4 "foundRadius: Function not yet Programmed."
	k = length(T) - 1
	@assert k <= dim +1 "foundRadius: too much points."

	center = AlphaStructures.foundCenter(T)
	if any(isnan, center)
		r = Inf
	else
		r =	findmin([Lar.norm(center - T[i]) for i = 1 : length(T)])[1]
	end

	return r
end


"""
	vertexInCircumball(
		T::Array{Array{Float64,1},1},
		α_char::Float64,
		point::Array{Float64,2}
	)::Bool

Determine if a point is inner of the circumball determined by `T` points
	and radius `α_char`.
"""
function vertexInCircumball(
		T::Array{Array{Float64,1},1},
		α_char::Float64,
		point::Array{Float64,2}
	)::Bool

	center = AlphaStructures.foundCenter(T)
	return Lar.norm(point - center) < α_char
end
