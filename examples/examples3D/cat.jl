using AlphaStructures
using ViewerGL
GL =  ViewerGL

"""
Return points from file.
"""
function load_points(filename::String)::Matrix
    io = open(filename, "r")
    point = readlines(io)
    close(io)

    b = [tryparse.(Float64,split(point[i], " ")) for i in 1:length(point)]
    V = hcat(b...)
    return V
end

V = load_points("examples/examples3D/model/cat.txt")

# view points
GL.VIEW([
	GL.GLPoints(permutedims(V))
])

filtration = AlphaStructures.alphaFilter(V);
VV, EV, FV, TV = AlphaStructures.alphaSimplex(V, filtration, 0.9)

# view all simplices
GL.VIEW(
	[
		GL.GLGrid(V, EV, GL.COLORS[1], 0.6) # White
		GL.GLGrid(V, FV, GL.COLORS[2], 0.3) # Red
		GL.GLGrid(V, TV, GL.COLORS[3], 0.3) # Green
	]
);

#
# Arlecchino's Cat
#

filter_key = sort(unique(values(filtration)))
granular = 7
reduced_filter = filter_key[sort(abs.(rand(Int, granular).%length(filter_key)))]
reduced_filter = [reduced_filter; max(filter_key...)]
points = [[p] for p in VV]

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


#
# Appearing Colors
#

#=
for i = 2 : length(reduced_filter)
	VV0, EV0, FV0, TV0 = AlphaStructures.alphaSimplex(V, filtration, reduced_filter[i-1])
	VV,  EV,  FV,  TV = AlphaStructures.alphaSimplex(V, filtration, reduced_filter[i])
	EV0mesh = GL.GLGrid(V, EV0)
	FV0mesh = GL.GLGrid(V, FV0)
	TV0mesh = GL.GLGrid(V, TV0)
	EVmesh = GL.GLGrid(V, setdiff(EV, EV0), GL.COLORS[2], 1)
	FVmesh = GL.GLGrid(V, setdiff(FV, FV0), GL.COLORS[7], 1)
	TVmesh = GL.GLGrid(V, setdiff(TV, TV0), GL.COLORS[12], 1)
	GL.VIEW([EV0mesh; FV0mesh; TV0mesh; EVmesh; FVmesh; TVmesh])
end
=#
