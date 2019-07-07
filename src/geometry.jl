"""
	Update(element,list)

Return update `list`: if `element` ∈ `list`, delete `element`, else push the `element`.
"""
function Update(element,list)
    if element ∈ list
        setdiff!(list, [element])
    else push!(list,element)
	end
	return list
end

"""
	RightSide(point::Array{Float64,1}, axis::Array{Float64,1}, off::Float64)::Int64

Return
	- `0`  if the point is on plane defined by normal `axis` and point `off`.
	- `1`  if the point is in the positive half-space indicated by plane defined by normal `axis` and point `off`.
	- `-1`  if the point is in the negatice half-space indicated by plane defined by normal `axis` and point `off`.
"""
function SidePlane(point::Array{Float64,1}, axis::Array{Float64,1}, off::Float64)::Int64
	side = round(Lar.dot(point,axis), sigdigits = 14)
	if  side == off return 0
	elseif side > off return 1
	elseif side < off return -1
	end
end

"""
    SplitValue(P::Lar.Points, axis::Array{Float64,1})

Return threshold value for splitting plane α of pointset `P`. The splitting
plane α is selected as a plane orthogonal to the axes (X, Y or Z in E^3 ), so:
	- axis = [1.,0,0] or
	- axis = [0,1.,0] or
	- axis = [0,0,1.].
"""
function SplitValue(P::Lar.Points, axis::Array{Float64,1})
	@assert axis == [1.,0,0] || axis == [0,1.,0] || axis == [0,0,1.] "Error: not a plane orthogonal to the axes "
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
	side = [AlphaShape.SidePlane(P[:,i],axis,off) for i = 1:size(P,2)]
	Pminus = P[:,side.== -1 ] #points in NegHalfspace(α)
    Pplus = P[:,side.== 1] #points in PosHalfspace(α)
    return Pminus,Pplus
end

"""
    Faces(t::Array{Int64,1})::Array{Array{Int64,1},1}

Return `d-1`-faces of a `d`-simplex.
"""
function Faces(t::Array{Int64,1})::Array{Array{Int64,1},1}
    d = length(t)
    return collect(Combinatorics.combinations(t, d-1))
end

"""
	distPointPlane(point::Array{Float64,1},axis::Array{Float64,1},off::Float64)::Float64

Return the distance between `point` and plane α defined by `axis` and `off`.
"""
function distPointPlane(point::Array{Float64,1},axis::Array{Float64,1},off::Float64)::Float64
	num = abs(axis[1]*point[1]+axis[2]*point[2]+axis[3]*point[3]-off)
	den = sqrt(axis[1]^2+axis[2]^2+axis[3]^2)
	return num/den
end

"""
	Intersect(P::Lar.Points, f::Array{Int64,1} ,axis::Array{Int8,1}, off::Float64)::Int64

Given a face f and a plane α returns
 -   0 if f intersect α
 -  -1 if f is completely contained in NegHalfspace(α)
 -   1 if f is completely contained in PosHalfspace(α)
"""
function Intersect(Ptot::Lar.Points, P::Lar.Points, f::Array{Int64,1} ,axis::Array{Float64,1}, off::Float64)::Int64

	p1,p2,p3 = [Ptot[:,i] for i in f]

	v1 = SidePlane(p1, axis, off)
	v2 = SidePlane(p2, axis, off)

	if v1 != v2
		return 0;
	end

 	v3 = SidePlane(p3, axis, off)

	#@assert v1 != 0 &&  v2 != 0 && v3 != 0 "Error: Face on Plane"

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
	@assert length(T) > 0 "ERROR: at least one points is needed."
	dim = length(T[1])
	@assert dim < 4 "Error: Function not yet Programmed."
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

""" DaRinominare foundRadius
	foundRadius(T::Array{Array{Float64,1},1})::Float64

Return the value of the circumball radius of the given points.
If three or more points are collinear it returns `NaN`.
"""
function foundRadius(T::Array{Array{Float64,1},1})::Float64

	@assert length(T) > 0 "ERROR: at least one points is needed."
	dim = length(T[1])
	@assert dim < 4 "Error: Function not yet Programmed."
	k = length(T) - 1
	@assert k <= dim +1 "ERROR: too much points."

	center = AlphaShape.foundCenter(T)
	alpha = round(Lar.norm(T[1] - center), sigdigits = 14) # number approximation

	return alpha
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

	center = AlphaShape.foundCenter(T)
	return Lar.norm(point - center) <= α_char
end
