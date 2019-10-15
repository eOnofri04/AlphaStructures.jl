using AlphaStructures
using LinearAlgebraicRepresentation, ViewerGL
Lar = LinearAlgebraicRepresentation
GL =  ViewerGL

include("./OBJ/cat.jl")
## Equivalent to the following instructions:
# V = Lar.obj2lar("examples/OBJ/cat.obj")[1];
# VS = AlphaStructures.matrixPerturbation(V);
# DT = AlphaStructures.delaunayWall(V);

filtration = AlphaStructures.alphaFilter(VS, DT);
filter_key = sort(unique(values(filtration)))


VV, EV, FV, TV = AlphaStructures.alphaSimplex(VS, filtration, 0.9)
GL.VIEW(
	[
		GL.GLGrid(VS, EV, GL.COLORS[1], 0.6) # White
		GL.GLGrid(VS, FV, GL.COLORS[2], 0.3) # Red
		GL.GLGrid(VS, TV, GL.COLORS[3], 0.3) # Green
	]
);

#
# Arlecchino's Cat
#

granular = 7
reduced_filter = filter_key[sort(abs.(rand(Int, granular).%length(filter_key)))]
reduced_filter = [reduced_filter; max(filter_key...)]
points = [[p] for p in VV]

for α in reduced_filter
	@show α
	VV,EV,FV,TV = AlphaStructures.alphaSimplex(VS, filtration, α)
	GL.VIEW(
		GL.GLExplode(
			VS,
			[[[t] for t in TV]; [[f] for f in FV]; [[e] for e in EV]],
			1., 1., 1.,	# Explode Ratio
			99, 1		# Colors
		)
	)
end


#
# Appearing Colors
#

#=
for i = 2 : length(reduced_filter)
	VV0, EV0, FV0, TV0 = AlphaStructures.alphaSimplex(VS, filtration, reduced_filter[i-1])
	VV,  EV,  FV,  TV = AlphaStructures.alphaSimplex(VS, filtration, reduced_filter[i])
	EV0mesh = GL.GLGrid(VS, EV0)
	FV0mesh = GL.GLGrid(VS, FV0)
	TV0mesh = GL.GLGrid(VS, TV0)
	EVmesh = GL.GLGrid(VS, setdiff(EV, EV0), GL.COLORS[2], 1)
	FVmesh = GL.GLGrid(VS, setdiff(FV, FV0), GL.COLORS[7], 1)
	TVmesh = GL.GLGrid(VS, setdiff(TV, TV0), GL.COLORS[12], 1)
	GL.VIEW([EV0mesh; FV0mesh; TV0mesh; EVmesh; FVmesh; TVmesh])
end
=#
