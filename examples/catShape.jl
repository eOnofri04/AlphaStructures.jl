using AlphaStructures
using LinearAlgebraicRepresentation, ViewerGL
Lar = LinearAlgebraicRepresentation
GL =  ViewerGL

include("./OBJ/cat.jl")

#GL.VIEW([ GL.GLGrid(Vi, VVi) ])
#GL.VIEW(Ve, VVe)

filtration = AlphaStructures.alphaFilter(VS, DT);
VV, EV, FV, TV = AlphaStructures.alphaSimplex(VS, filtration, 0.02)

points = [[p] for p in VV]
# faces = [[f] for f in FV]
# edges = [[e] for e in EV]
# GL.VIEW( GL.GLExplode(Vi, [points; edges; faces], 1., 1., 1., 99, 1) )

filter_key = unique(keys(filtration))

granular = 15

reduced_filter = filter_key[sort(abs.(rand(Int, granular).%length(filter_key)))]
reduced_filter = [reduced_filter; 1.]

for α in reduced_filter
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

# for i = 1000 : 150 : length(filter_key)
# 	VV,EV,FV = AlphaStructures.alphaSimplex(V, filtration, filter_key[i])
# 	GL.VIEW(
# 		GL.GLExplode(
# 			Vi,
# 			[[[f] for f in FV]; [[e] for e in EV]],
# 			1., 1., 1.,	# Explode Ratio
# 			99, 1		# Colors
# 		)
# 	)
# end
