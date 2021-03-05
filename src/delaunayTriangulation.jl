"""
	delaunayTriangulation(V::Matrix)::Array{Array{Int64,1},1}

Return highest level simplices of Delaunay triangulation.

# Examples 1D
```jldoctest

julia> V = [1. 2. 5. 6. 0. 7.];

julia> DT = AlphaStructures.delaunayTriangulation(V)
5-element Array{Array{Int64,1},1}:
 [1, 5]
 [1, 2]
 [2, 3]
 [3, 4]
 [4, 6]
```

# Examples 2D
```jldoctest

julia> V = [
 1. 2. 1. 2. ;
 0. 0. 1. 2.
];

julia> DT = AlphaStructures.delaunayTriangulation(V)
2-element Array{Array{Int64,1},1}:
 [1, 2, 3]
 [2, 3, 4]
```

# Examples 3D
```jldoctest

julia> V = [
 1. 2. 1. 2. ;
 0. 0. 1. 2. ;
 3. 1. 0. 2.
];

julia> DT = AlphaStructures.delaunayTriangulation(V)
1-element Array{Array{Int64,1},1}:
 [1, 2, 3, 4]
```
"""
function delaunayTriangulation(V::Matrix)::Array{Array{Int64,1},1}
	dim = size(V, 1)
	@assert dim > 0 "delaunayTriangulation: V do not contains points."
	@assert dim < 4 "delaunayTriangulation: Function not yet Programmed."

	if dim == 1
		vertices = vcat(V...)
		p = sortperm(vertices)
		upper_simplex = [[p[i],p[i+1]] for i=1:length(p)-1]
		return sort(sort.(upper_simplex))

	else
		upper_simplex = DelaunayTriangulation(V)
		return sort(upper_simplex)
	end

end

"""
    delaunay_triangulation(points::Matrix) -> Array{Array{Int64,1},1}

Delaunay triangulation of points in d-dimensional Euclidean space.
Lar interface of Delaunay.jl.
"""
function DelaunayTriangulation(points::Matrix)

	centroid(points::Union{Matrix,Array{Float64,1}}) = (sum(points,dims=2)/size(points,2))[:,1]

    centroid = centroid(points)
    T = apply_matrix(traslation(-centroid...),points)
    mesh = delaunay(permutedims(T));
    DT = [mesh.simplices[c,:] for c in 1:size(mesh.simplices,1)]
    return sort.(DT)
end

#
# """
# 	delaunayMATLAB(V::Matrix)
#
# Delaunay triangulation algorithm in MATLAB.
# """
# function delaunayMATLAB(V::Matrix)
#
# 	dim = size(V,1)
# 	@assert dim <=3 "delaunayMATLAB: input points have invalid dimension."
#
# 	W = convert(Matrix,V')
# 	@mput W
# 	mat"DT = delaunay(W)"
# 	@mget DT
# 	DT = convert(Array{Int64,2},DT)
# 	DT = [DT[i,:] for i in 1:size(DT,1)]
#
# 	return DT
# end
