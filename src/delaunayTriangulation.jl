"""
	delaunayMATLAB(V::Lar.Points)

Delaunay triangulation algorithm in MATLAB.
"""
function delaunayMATLAB(V::Lar.Points)

	dim = size(V,1)
	@assert dim <=3 "delaunayMATLAB: input points have invalid dimension."

	W = convert(Lar.Points,V')
	@mput W
	mat"DT = delaunay(W)"
	@mget DT
	DT = convert(Array{Int64,2},DT)
	DT = [DT[i,:] for i in 1:size(DT,1)]

	return DT
end

"""
	DTprojxy(V::Lar.Points)

Delaunay triangulation projected on xy plane with MATLAB algorithm.
"""
function DTprojxy(V::Lar.Points)
	W = convert(Lar.Points,V')[:,[1,2]]
	@mput W
	mat"DT = delaunay(W)"
	@mget DT
	DT = convert(Array{Int64,2},DT)
	DT = [DT[i,:] for i in 1:size(DT,1)]
	return DT
end
