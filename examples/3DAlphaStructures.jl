using AlphaStructures
using LinearAlgebraicRepresentation, Plasm,ViewerGL
Lar = LinearAlgebraicRepresentation
GL = ViewerGL

#filename = "examples/OBJ/lowpolytree.obj";
filename = "examples/OBJ/teapot.obj";
W,EVs,FVs = Lar.obj2lar(filename);
WW = [[i] for i = 1:size(W,2)];
V,VV = Lar.apply(Lar.r(pi/2, 0, 0),(W,WW)); #object rotated

points = convert(Lar.Points,V')
GL.VIEW([
    GL.GLPoints(points)
	GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(1,1,1))
]);

filtration = AlphaStructures.alphaFilter(V);
VV, EV, FV, TV = AlphaStructures.alphaSimplex(V, filtration, 0.02)

points = [[p] for p in VV]

filter_key = unique(keys(filtration))

granular = 15

reduced_filter = filter_key[sort(abs.(rand(Int, granular).%length(filter_key)))]
reduced_filter = [reduced_filter; 1.]

for α in reduced_filter
	VV,EV,FV,TV = AlphaStructures.alphaSimplex(V, filtration, α)
	GL.VIEW(
		GL.GLExplode(
			V,
			[[[t] for t in TV]; [[f] for f in FV]; [[e] for e in EV]],
			1., 1., 1.,	# Explode Ratio
			99, 1		# Colors
		)
	)
end