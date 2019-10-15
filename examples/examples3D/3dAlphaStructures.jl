using AlphaStructures
using LinearAlgebraicRepresentation, ViewerGL
Lar = LinearAlgebraicRepresentation
GL = ViewerGL

#filename = "./OBJ/lowpolytree.obj";
filename = "examples/examples3D/OBJ/teapot.obj";
W,EVs,FVs = Lar.obj2lar(filename);
WW = [[i] for i = 1 : size(W, 2)];
V,VV = Lar.apply(Lar.r(pi/2, 0, 0), (W, WW)); #object rotated

points = convert(Lar.Points, V')
GL.VIEW([
    GL.GLPoints(points)
	GL.GLAxis(GL.Point3d(-1, -1, -1), GL.Point3d(1, 1, 1))
]);

filtration = AlphaStructures.alphaFilter(V);
VV, EV, FV, TV = AlphaStructures.alphaSimplex(V, filtration, 3.7)

GL.VIEW(
	[
		GL.GLGrid(V, EV, GL.COLORS[1], 0.6) # White
		GL.GLGrid(V, FV, GL.COLORS[2], 0.3) # Red
		GL.GLGrid(V, TV, GL.COLORS[3], 0.3) # Green
	]
);

filter_key = sort(unique(values(filtration)))

granular = 10

reduced_filter = filter_key[sort(abs.(rand(Int, granular).%length(filter_key)))]
reduced_filter = [reduced_filter; max(filter_key...)]

for α in reduced_filter
	@show α
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
