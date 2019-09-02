using AlphaStructures
using LinearAlgebraicRepresentation, ViewerGL
Lar = LinearAlgebraicRepresentation
GL =  ViewerGL

"""
	pointsRand(V, EV, n, m)

Generate random points inside and otuside `(V, EV)`.

Given a Lar complex `(V, EV)`, this method evaluates and gives back:
 - `Vi` made of `n` internal random points;
 - `Ve` made of `m` external random points;
 - `VVi` made of `n` single point 0-cells;
 - `VVe` made of `m` single point 0-cells.

---

# Arguments
 - `V::Lar.Points`: The coordinates of points of the original complex;
 - `EV::Lar.Cells`: The 1-cells of the original complex;
 - `n::Int64`: the number of internal points (*By default* = 1000);
 - `m::Int64`: the number of external points (*By default* = 0);

"""
function pointsRand(
		V::Lar.Points, EV::Lar.Cells, n = 1000, m = 0
	)::Tuple{Lar.Points, Lar.Points, Lar.Cells, Lar.Cells}
	classify = Lar.pointInPolygonClassification(V, EV)
	Vi = [0;0]
	Ve = [0;0]
	k1 = 0
	k2 = 0
	while k1 < n || k2 < m
		queryPoint = [rand();rand()]
		inOut = classify(queryPoint)

		if k1 < n && inOut == "p_in"
			Vi = hcat(Vi, queryPoint)
			k1 = k1 + 1;
		end
		if k2 < m && inOut == "p_out"
			Ve = hcat(Ve, queryPoint)
			k2 = k2 + 1;
		end
	end
	VVi = [[i] for i = 1 : n]
	VVe = [[i] for i = 1 : m]
	return Vi[:,2:end], Ve[:,2:end], VVi, VVe
end


filename = "examples/svg_files/Lar2.svg";
V,EV = Lar.svg2lar(filename);

Vi, Ve, VVi, VVe = pointsRand(V, EV, 1000, 10000);

GL.VIEW([
	GL.GLGrid(Vi, VVi, GL.COLORS[1], 1)
	GL.GLGrid(Ve, VVe, GL.COLORS[12], 1)
])

filtration = AlphaStructures.alphaFilter(Vi);
VV,EV,FV = AlphaStructures.alphaSimplex(Vi, filtration, 0.02)

points = [[p] for p in VV]
faces = [[f] for f in FV]
edges = [[e] for e in EV]
GL.VIEW( GL.GLExplode(Vi, [edges; faces], 1.5, 1.5, 1.5, 99, 1) );

filter_key = unique(keys(filtration))

granular = 15

reduced_filter = filter_key[sort(abs.(rand(Int, granular).%length(filter_key)))]
reduced_filter = [reduced_filter; max(filter_key...)]

#
# Arlecchino's Lar
#

for α in reduced_filter
	VV,EV,FV = AlphaStructures.alphaSimplex(Vi, filtration, α)
	GL.VIEW(
		GL.GLExplode(
			Vi,
			[[[f] for f in FV]; [[e] for e in EV]],
			1., 1., 1.,	# Explode Ratio
			99, 1		# Colors
		)
	)
end

#=
for i = 1000 : 150 : length(filter_key)
	VV,EV,FV = AlphaStructures.alphaSimplex(Vi, filtration, filter_key[i])
	GL.VIEW(
		GL.GLExplode(
			Vi,
			[[[f] for f in FV]; [[e] for e in EV]],
			1., 1., 1.,	# Explode Ratio
			99, 1		# Colors
		)
	)
end
=#

#
# Appearing Colors
#

#=
reduced_filter = [
	0.001;	0.002;	0.003;	0.004;	0.005
	0.006;	0.007;	0.008;	0.009;	0.010
	0.013;	0.015;	0.020;	0.050;	1.000
]

for i = 2 : length(reduced_filter)
	VV0, EV0, FV0 = AlphaStructures.alphaSimplex(Vi, filtration, reduced_filter[i-1])
	VV,  EV,  FV  = AlphaStructures.alphaSimplex(Vi, filtration, reduced_filter[i])
	EV0mesh = GL.GLGrid(Vi, EV0)
	FV0mesh = GL.GLGrid(Vi, FV0)
	EVmesh = GL.GLGrid(Vi, setdiff(EV, EV0), GL.COLORS[2], 1)
	FVmesh = GL.GLGrid(Vi, setdiff(FV, FV0), GL.COLORS[7], 1)
	GL.VIEW([EV0mesh; FV0mesh; EVmesh; FVmesh])
end
=#
