using LinearAlgebraicRepresentation, AlphaStructures, ViewerGL
Lar = LinearAlgebraicRepresentation
GL = ViewerGL

fname0 = "examples/PointCloud/pointCloud/CUPOLALevel2/r0.las"
fname1 = "examples/PointCloud/pointCloud/CUPOLALevel2/r1.las"
fname2 = "examples/PointCloud/pointCloud/CUPOLALevel2/r2.las"
fname3 = "examples/PointCloud/pointCloud/CUPOLALevel2/r3.las"
fname4 = "examples/PointCloud/pointCloud/CUPOLALevel2/r4.las"

Vtot,VV,rgb = AlphaStructures.loadlas(fname0,fname1,fname2,fname3,fname4)
V,a = Lar.apply(Lar.t(-min(Vtot[1,:]...),-min(Vtot[2,:]...),-min(Vtot[3,:]...)),[Vtot,[1]])


GL.VIEW(
	[
		AlphaStructures.colorview(V,VV,rgb)
	]
);

#include("pointCloud/CUPOLALevel2/DT.jl")
include("./pointCloud/CUPOLALevel2/part0.jl")
include("./pointCloud/CUPOLALevel2/part1.jl")
include("./pointCloud/CUPOLALevel2/part2.jl")
include("./pointCloud/CUPOLALevel2/part3.jl")
include("./pointCloud/CUPOLALevel2/part4.jl")

#Equivalent to =>
#DT = AlphaStructures.delaunayTriangulation(V);
DT = union(part0,part1,part2,part3,part4)
filtration = AlphaStructures.alphaFilter(V, DT);

α = 0.25
VV, EV, FV, TV = AlphaStructures.alphaSimplex(V, filtration, α)

GL.VIEW(
	[
		AlphaStructures.colorview(V,FV,rgb)
	]
);


#=
open("DT.jl", "w") do f
	write(f, "[")
	for simplex in DT
		write(f, "[")
		for i in simplex
    		write(f, "$i,")
		end
		write(f, "],")
	end
	write(f, "]")
end
=#
