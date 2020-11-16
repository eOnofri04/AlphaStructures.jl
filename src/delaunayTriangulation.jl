"""
	delaunayTriangulation(V::Lar.Points)::Lar.Cells

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
function delaunayTriangulation(points::Lar.Points)
    V = convert(Lar.Points,points')
    mesh = delaunay(V);
    DT = [mesh.simplices[c,:] for c in 1:size(mesh.simplices,1)]
    return sort.(DT)
end


#---------------------------------- OLD --------------------------------------
# function delaunayTriangulation(V::Lar.Points)::Lar.Cells
# 	dim = size(V, 1)
# 	@assert dim > 0 "delaunayTriangulation: V do not contains points."
# 	@assert dim < 4 "delaunayTriangulation: Function not yet Programmed."
#
# 	if dim == 1
# 		vertices = vcat(V...)
# 		p = sortperm(vertices)
# 		upper_simplex = [[p[i],p[i+1]] for i=1:length(p)-1]
#
# 	elseif dim == 2
# 		vertices = convert(Array{Float64,2},V')
# 		points_map = Array{Int64,1}(collect(1:1:size(vertices)[1]))
# 		@assert size(vertices, 1) > 3
# 		upper_simplex = Triangle.basic_triangulation(vertices, points_map)
#
# 	elseif dim == 3
# 		upper_simplex = AlphaStructures.delaunayWall(V)
# 	end
#
# 	sort!.(upper_simplex)
#
# 	return sort(upper_simplex)
# end
#
# """
# 	delaunayMATLAB(V::Lar.Points)
#
# Delaunay triangulation algorithm in MATLAB.
# """
#
# function delaunayTriangulation(V::Lar.Points)::Lar.Cells
# 	return delaunayMATLAB(V)
# end
#
#
# function delaunayMATLAB(V::Lar.Points)
#
# 	dim = size(V,1)
# 	@assert dim <=3 "delaunayMATLAB: input points have invalid dimension."
#
# 	W = convert(Lar.Points,V')
# 	@mput W
# 	mat"DT = delaunay(W)"
# 	@mget DT
# 	DT = convert(Array{Int64,2},DT)
# 	DT = [DT[i,:] for i in 1:size(DT,1)]
#
# 	return DT
# end
#
