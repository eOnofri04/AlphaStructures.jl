using LinearAlgebraicRepresentation, AlphaStructures, ViewerGL
Lar = LinearAlgebraicRepresentation
GL = ViewerGL

fname = "examples/PointCloud/pointCloud/SCALE/r.las"
Vtot,VV,rgb = AlphaStructures.loadlas(fname)
V,a = Lar.apply(Lar.t(-min(Vtot[1,:]...),-min(Vtot[2,:]...),-min(Vtot[3,:]...)),[Vtot,[1]])

GL.VIEW(
	[
		AlphaStructures.colorview(V,VV,rgb)
	]
);


include("./pointCloud/SCALE/VS.jl")
include("./pointCloud/SCALE/DT.jl")
#=
#Equivalent to =>
V = AlphaStructures.matrixPerturbation(V);
DT = AlphaStructures.delaunayTriangulation(V);
=#

filtration = AlphaStructures.alphaFilter(V, DT);

α =  0.0467882
VV, EV, FV, TV = AlphaStructures.alphaSimplex(V, filtration, α);

GL.VIEW(
	[
		AlphaStructures.colorview(V,FV,rgb)
	]
);
